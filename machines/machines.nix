{ inputs, config, ... }:
let
  inherit (inputs.nixpkgs) lib;
  inherit (lib) mkOption types;
  inherit (config.flake) machines modules;
  inherit (config.flake.types) userSubmodule;

  mkModulesOption = mkOption {
    type = with types; listOf deferredModule;
    default = [];
  };
in
{
  options.flake.machines = mkOption {
    default = {};
    type = with types; lazyAttrsOf (submodule {
      options = {
        hardware = mkModulesOption;
        modules = mkModulesOption;
        networks = mkModulesOption;
        system = mkOption { type = enum config.systems; };
        users = mkOption {
          default = {};
          type = attrsOf userSubmodule;
        };
      };
    });
  };

  config.flake.nixosConfigurations = lib.genAttrs (lib.attrNames machines)
  (host: let
    inherit (machines.${host}) users system;
  in lib.nixosSystem {
    inherit system;
    modules =
      machines.${host}.modules
      ++ machines.${host}.hardware
      ++ machines.${host}.networks
      ++ lib.optionals (users != {}) [{
        users.users = lib.mapAttrs (_: ucfg: {
          isNormalUser = true;
          extraGroups = ucfg.groups;
          packages = ucfg.packages;
          shell = lib.mkIf (ucfg.shell != null) ucfg.shell;
        }) users;
      }]
      ++ [
        modules.nixos.nix-config
        modules.nixos.systemd-boot

        {
          networking.hostName = host;
          time.timeZone = lib.mkDefault "America/Chicago";

          nixpkgs.overlays = [
            (_: _: {
              bin = inputs.bin.packages.${system};
              regolith = config.flake.packages.${system};

              unstable = import inputs.nixpkgs-unstable {
                inherit system;
                config.allowUnfree = true;
              };
            })
          ];

          i18n = let
            defaultLocale = "en_US.UTF-8";
          in {
            inherit defaultLocale;
            extraLocaleSettings = {
              LC_ADDRESS = defaultLocale;
              LC_IDENTIFICATION = defaultLocale;
              LC_MEASUREMENT = defaultLocale;
              LC_MONETARY = defaultLocale;
              LC_NAME = defaultLocale;
              LC_NUMERIC = defaultLocale;
              LC_PAPER = defaultLocale;
              LC_TELEPHONE = defaultLocale;
              LC_TIME = defaultLocale;
            };
          };
        }
      ];
  });
}
