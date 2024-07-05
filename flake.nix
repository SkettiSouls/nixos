{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    lynx.url = "github:the-computer-club/lynx";
    asluni.url = "github:the-computer-club/automous-zones";
    neovim.url = "github:skettisouls/neovim";
    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/hyprland";
      submodules = true;
    };
    hyprpicker.url = "github:hyprwm/hyprpicker";
    schizofox.url = "github:schizofox/schizofox";
    vesktop.url = "github:NixOS/nixpkgs/nixos-unstable";
    midnight-discord = {
      type = "git";
      url = "https://github.com/refact0r/midnight-discord";
      flake = false;
    };
  };

  outputs = inputs @ { self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; }
      ({ config, options, flake-parts-lib, ... }:
        let
          inherit (config.flake.lib)
            listToAttrs'
            ;

          inherit (nixpkgs.lib)
            genAttrs
            mapAttrs
            mkDefault
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
                specialArgs = { inherit inputs self; };
                modules = with config.flake; [
                  hostModules.${host}
                  hardwareModules.${host}
                  nixosModules.default
                  # Pass host down to userModules.default
                  (userModules.default { machine = host; })
                  ./global.nix
                  ./overlays.nix
                  # Share state version with home-manager
                  { home-manager.sharedModules = [{ home.stateVersion = config.flake.nixosConfigurations.${host}.config.system.stateVersion; }]; }
                ];
              });

              # FIXME: Infinite recursion when using schizofox.
              homeConfigurations = mapAttrs (user: hostList:
                listToAttrs' (map (host: { ${host} =
                  inputs.home-manager.lib.homeManagerConfiguration {
                    pkgs = nixpkgs.legacyPackages.x86_64-linux;
                    extraSpecialArgs = { inherit inputs self; };
                    modules = with config.flake; [
                      ./flake-sharts/homes/${user}/${host}.nix
                      homeModules.default
                      userModules.${user}
                      ./overlays.nix
                      {
                        home = rec {
                          username = "${user}";
                          homeDirectory = mkDefault "/home/${username}";
                          stateVersion = config.flake.nixosConfigurations.${host}.config.system.stateVersion;
                        };
                      }
                    ];
                  };
                }) hostList)
              ) config.homes;
            };
          };
        });

}
