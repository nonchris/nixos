# nix run .\#woodpecker-pipeline
{
  pkgs,
  lib,
  hostMeta,
  ...
}:
with pkgs;
let
  supportedSystems = [
    "aarch64-linux"
    "x86_64-linux"
  ];

  woodpecker-platforms = {
    "aarch64-linux" = "linux/arm64";
    "x86_64-linux" = "linux/amd64";
  };

  woodpecker-filenames = {
    "aarch64-linux" = "arm64-linux.yaml";
    "x86_64-linux" = "x86-linux.yaml";
  };

  flake-preview-update-filenames = {
    "aarch64-linux" = "flake-preview-update-arm64.yaml";
    "x86_64-linux" = "flake-preview-update-x86.yaml";
  };

  hosts = builtins.attrNames hostMeta;
  checkedHosts = lib.filter (host: hostMeta.${host}.inChecks) hosts;

  # Only generate pipelines for architectures used by at least one nixosConfiguration
  activeSystems = lib.filter (
    system: lib.any (host: hostMeta.${host}.system == system) checkedHosts
  ) supportedSystems;

  pipelineFor = lib.genAttrs activeSystems (
    system:
    writeText "pipeline" (
      builtins.toJSON {
        configs =
          let
            nixFlakeShow = {
              name = "Nix flake show";
              image = "bash";
              commands = [ "nix flake show" ];
            };
            atticSetupStep = {
              name = "Setup Attic";
              image = "bash";
              commands = [
                "attic login lounge-rocks https://cache.lounge.rocks $ATTIC_KEY --set-default"
              ];
              environment = {
                ATTIC_KEY.from_secret = "attic_key";
              };
            };
            nixFastBuildStep = {
              name = "Build all outputs for this architecture";
              image = "bash";
              failure = "ignore";
              commands = [
                ''nix-fast-build --no-nom --skip-cached --attic-cache lounge-rocks:nix-cache --flake ".#checks.${system}"''
              ];
            };
            verifyBuildsStep =
              arch:
              let
                activeHosts = lib.filter (host: hostMeta.${host}.system == arch) checkedHosts;
              in
              {
                name = "Verify all builds succeeded";
                image = "bash";
                commands = map (host: "test -e 'result-${host}'") activeHosts ++ [
                  "echo 'All builds succeeded.'"
                ];
              };
          in
          pkgs.lib.lists.flatten ([
            (map
              (arch: {
                name = "Hosts with arch: ${arch}";
                data = (
                  builtins.toJSON {
                    labels = {
                      backend = "local";
                      platform = woodpecker-platforms."${arch}";
                    };
                    when = pkgs.lib.lists.flatten ([
                      { event = "manual"; }
                      {
                        event = "push";
                        branch = "main";
                      }
                      {
                        event = "push";
                        branch = "update_flake_lock_action";
                      }
                    ]);
                    steps = pkgs.lib.lists.flatten (
                      # [ nixFlakeShow ]
                      [ atticSetupStep ]
                      ++ [ nixFastBuildStep ]
                      ++ [ (verifyBuildsStep arch) ]
                      ++ (map (
                        host:
                        # only build hosts for the arch we are currently building
                        if (hostMeta.${host}.system != arch) then
                          [ ]
                        # Only include hosts that are part of flake checks
                        else if !hostMeta.${host}.inChecks then
                          [ ]
                        else
                          [
                            {
                              name = "Rebuild ${host} (diagnostic)";
                              image = "bash";
                              failure = "ignore";
                              "when" = {
                                "status" = "failure";
                              };
                              commands = [
                                "nix build --print-out-paths '.#nixosConfigurations.${host}.config.system.build.toplevel' -o 'result-${host}'"
                              ];
                            }
                            {
                              name = "Show ${host} info";
                              image = "bash";
                              failure = "ignore";
                              "when" = {
                                "status" = [
                                  "failure"
                                  "success"
                                ];
                              };
                              commands = [
                                "nix path-info --closure-size -h $(readlink -f 'result-${host}')"
                              ];
                            }
                          ]
                      ) hosts)
                    );
                  }
                );
              })
              [
                "${system}"
              ]
            )
          ]);
      }
    )
  );

  flakePreviewUpdatePipelineFor = lib.genAttrs supportedSystems (
    system:
    writeText "flake-preview-update-${system}" (
      builtins.toJSON {
        labels = {
          backend = "local";
          platform = woodpecker-platforms."${system}";
        };
        when = [ { event = "manual"; } ];
        steps = [
          {
            name = "Run flake-preview-update";
            image = "bash";
            commands = [
              "nix run .#flake-preview-update -- -all -systems ${system}"
            ];
          }
          {
            name = "Show diff summary";
            image = "bash";
            commands = [
              "cat diff_lists/summary.txt"
            ];
          }
        ];
      }
    )
  );

  sdImagePipeline = writeText "sd-image-pipeline" (
    builtins.toJSON {
      configs = [
        {
          name = "Build and upload arm64 SD image";
          data = builtins.toJSON {
            labels = {
              backend = "local";
              platform = woodpecker-platforms."aarch64-linux";
            };
            when = [
              {
                event = "manual";
                evaluate = ''SYSTEM_TO_BUILD != ""'';
              }
            ];
            steps = [
              {
                name = "Build SD image";
                image = "bash";
                commands = [
                  "nix build '.#nixosConfigurations.\${SYSTEM_TO_BUILD=pi4b}.config.system.build.sdImage'"
                ];
              }
              {
                name = "List build output";
                image = "bash";
                commands = [
                  "ls -al result/sd-image/*"
                ];
              }
              {
                name = "Upload SD image";
                image = "bash";
                environment = {
                  S3_URL = "https://s3.eu-central-003.backblazeb2.com";
                  S3_BUCKET = "crab-share";
                  S3_REGION = "eu-central-003";
                  S3_ACCESS_KEY = "003d560892a1b3a0000000002";
                  S3_SECRET_KEY.from_secret = "S3_SECRET_KEY";
                };
                commands = [
                  "crab_share --expires 7d --zip-single-file result/sd-image/*.img"
                ];
              }
            ];
          };
        }
      ];
    }
  );
in
pkgs.writeShellScriptBin "woodpecker-pipeline" ''
  # make sure .woodpecker folder exists
  mkdir -p .woodpecker

  # empty content of .woodpecker folder
  rm -rf .woodpecker/*

  # copy pipelines to .woodpecker folder (only for architectures present in the flake)
  ${lib.concatStrings (
    map (system: ''
      cat ${pipelineFor.${system}} | ${pkgs.jq}/bin/jq '.configs[].data' -r | ${pkgs.jq}/bin/jq > .woodpecker/${woodpecker-filenames.${system}}
    '') activeSystems
  )}
  ${lib.optionalString (lib.elem "aarch64-linux" activeSystems) ''
    cat ${sdImagePipeline} | ${pkgs.jq}/bin/jq '.configs[].data' -r | ${pkgs.jq}/bin/jq > .woodpecker/arm64-sd-image.yaml
  ''}
  # flake-preview-update pipelines for all supported architectures
  ${lib.concatStrings (
    map (system: ''
      cat ${flakePreviewUpdatePipelineFor.${system}} | ${pkgs.jq}/bin/jq > .woodpecker/${
        flake-preview-update-filenames.${system}
      }
    '') supportedSystems
  )}
''