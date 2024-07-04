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
            mapAttrs
            mkOption
            nixosSystem
            types
            ;

          mapHosts = map (host: { ${host} = ./hosts/${host}/configuration.nix; });

          flakeModules = {
            # features = importApply ./flake-sharts/features args;
            hardware = importApply ./flake-sharts/hardware args;
            home-manager = import ./flake-sharts/home-manager;
            # hosts = importApply ./flake-sharts/hosts args;
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
            nixos = mkOption { type = with types; attrsOf unspecified; };
            homes = mkOption { type = with types; attrsOf unspecified; };
          };

          config = {
            systems = [
              "x86_64-linux"
            ];

            nixos = listToAttrs' (mapHosts [
              "argon"
              "fluorine"
              "victus"
            ]);

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

              nixosConfigurations = mapAttrs (hostName: configFile: nixosSystem {
                specialArgs = { inherit inputs self; };
                modules = [
                  configFile
                  config.flake.nixosModules.default
                  config.flake.hardwareModules.${hostName}
                  ./global.nix
                  ./overlays.nix
                ];
              }) config.nixos;

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
                        # Share nixos stateVersion
                        home.stateVersion = config.flake.nixosConfigurations.${host}.config.system.stateVersion;
                      }
                    ];
                  };
                }) hostList)
              ) config.homes;
            };
          };
        });

}
