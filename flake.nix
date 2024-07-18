{
  inputs = {
    # Base
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland
    hyprpicker.url = "github:hyprwm/hyprpicker";
    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/hyprland";
      submodules = true;
    };

    neovim.url = "github:skettisouls/neovim";

    # Discord
    vesktop.url = "github:NixOS/nixpkgs/nixos-unstable"; # Allow updating vesktop independent of other unstable pkgs
    midnight-discord = {
      type = "git";
      url = "https://github.com/refact0r/midnight-discord";
      flake = false;
    };

    # Luni-net
    asluni.url = "github:the-computer-club/automous-zones";
    lynx.url = "github:the-computer-club/lynx";
  };

  outputs = inputs @ { self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; }
      ({ config, options, flake-parts-lib, ... }:
        let
          inherit (nixpkgs.lib)
            genAttrs
            mapAttrs
            mkOption
            nixosSystem
            types
            ;

          flakeModules = {
            # features = importApply ./flake-sharts/features args;
            hardware = import ./flake-sharts/hardware;
            home-manager.imports = [ ./flake-sharts/home-manager ./flake-sharts/home-manager/nixos-module.nix ];
            hosts = import ./flake-sharts/hosts;
            hyprland = import ./flake-sharts/hyprland;
            libs = import ./flake-sharts/libs;
            nixos = import ./flake-sharts/nixos;
            packages = import ./flake-sharts/packages;
            roles = import ./flake-sharts/roles;
            users = import ./flake-sharts/users;
            wireguard = import ./flake-sharts/wireguard;
          };

          hm-module = (builtins.head config.flake.nixosModules.home-manager.imports);
        in
        {
          imports = with flakeModules; [
            hardware
            home-manager
            hosts
            hyprland
            libs
            nixos
            packages
            roles
            users
            wireguard

            inputs.lynx.flakeModules.flake-guard
            inputs.asluni.flakeModules.asluni
          ];

          options = {
            homes = mkOption { type = with types; attrsOf unspecified; };
            machines = mkOption { type = with types; listOf unspecified; };
          };

          config = {
            systems = [
              "x86_64-linux"
            ];

            homes = {
              skettisouls = [
                "argon"
                "fluorine"
                "victus"
              ];
            };

            machines = [
              "argon"
              "fluorine"
              "victus"
            ];

            flake = {
              # Debug
              _config = config;
              _options = options;

              inherit flakeModules;

              nixosConfigurations = genAttrs config.machines (host: nixosSystem {
                specialArgs = { inherit inputs self; currentMachine = host; };
                modules = with config.flake; [
                  ./global.nix
                  ./overlays.nix
                  hostModules.${host}
                  hardwareModules.${host}
                  nixosModules.default
                  (hm-module { inherit host; })
                  (userModules.default { inherit host; })
                ];
              });

              # FIXME: Infinite recursion when using schizofox.
              homeConfigurations = mapAttrs (user: hostList:
                genAttrs hostList (host:
                  inputs.home-manager.lib.homeManagerConfiguration {
                    # TODO: Support other arch
                    pkgs = nixpkgs.legacyPackages.x86_64-linux;
                    extraSpecialArgs = { inherit inputs self; };
                    modules = [
                      ./overlays.nix
                      # Use the home-manager config from nixos.
                      (hm-module { inherit host; }).home-manager.users.${user}
                    ];
                  }
                )
              ) config.homes;
            };
          };
        });

}
