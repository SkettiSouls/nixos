{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    vesktop.url = "github:NixOS/nixpkgs/nixos-unstable";
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
    midnight-discord = {
      type = "git";
      url = "https://github.com/refact0r/midnight-discord";
      flake = false;
    };
  };

  outputs = inputs @ { self, nixpkgs, flake-parts, lynx, asluni, ... }:
    flake-parts.lib.mkFlake { inherit inputs; }
      (args @ { config, options, flake-parts-lib, ... }:
        let
          inherit (flake-parts-lib) importApply;

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
            hardware = importApply ./flake-sharts/hardware args;
            home-manager.imports = [
              ./flake-sharts/home-manager
              ./flake-sharts/home-manager/nixos-module.nix
            ];
            hosts = import ./flake-sharts/hosts;
            hyprland = import ./flake-sharts/hyprland;
            libs = importApply ./flake-sharts/libs args;
            nixos = importApply ./flake-sharts/nixos args;
            packages = importApply ./flake-sharts/packages args;
            roles = importApply ./flake-sharts/roles args;
            users = import ./flake-sharts/users;
            wireguard = importApply ./flake-sharts/wireguard args;
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
            nixos = mkOption { type = with types; listOf unspecified; };
            homes = mkOption { type = with types; attrsOf unspecified; };
          };

          config = {
            systems = [
              "x86_64-linux"
            ];

            nixos = [
              "argon"
              "fluorine"
              "victus"
            ];

            homes = {
              skettisouls = [
                "argon"
                "fluorine"
                "victus"
              ];
            };

            flake = {
              _config = config;
              _options = options;

              inherit flakeModules;

              nixosConfigurations = genAttrs config.nixos (host: nixosSystem {
                specialArgs = { inherit inputs self; };
                modules = [
                  config.flake.hostModules.${host}
                  config.flake.nixosModules.default
                  config.flake.hardwareModules.${host}
                  (config.flake.userModules.default { machine = host; })
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
                    modules = [
                      ./flake-sharts/homes/${user}/${host}.nix
                      config.flake.userModules.${user}
                      config.flake.homeModules.default
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
