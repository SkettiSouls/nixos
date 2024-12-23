{
  inputs = {
  # Base {{{
    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    wrapper-manager = {
      url = "github:viperML/wrapper-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  # }}}

  # Discord {{{
    boris = { # Bot
      url = "github:skettisouls/boris";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    midnight-discord = {
      type = "git";
      url = "https://github.com/refact0r/midnight-discord";
      flake = false;
    };

    nixcord = {
      url = "github:skettisouls/nixcord";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  # }}}

  # Hyprland {{{
    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/hyprland";
      submodules = true;
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "hyprland";
    };
  # }}}

  # Dev {{{
    bin = {
      url = "github:skettisouls/bin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    neovim = {
      url = "github:skettisouls/neovim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  # }}}

  # Server {{{
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-mc = {
      url = "github:skettisouls/nix-mc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  # }}}

  # Wireguard {{{
    asluni.url = "github:the-computer-club/automous-zones";
    lynx.url = "github:the-computer-club/lynx";
    peridot.url = "github:skettisouls/peridot";
  # }}}
  };

  outputs = inputs @ { self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; }
      ({ config, options, flake-parts-lib, ... }:
        let
          inherit (nixpkgs) lib;
          inherit (lib)
            genAttrs
            mapAttrs
            nixosSystem
            ;

          flakeModules = {
            hardware = import ./src/hardware;
            home-manager = import ./src/home-manager;
            libs = import ./src/libs;
            machines = import ./src/machines;
            nixos = import ./src/nixos;
            overlays = import ./src/overlays;
            packages = import ./src/packages;
            river = import ./src/river;
            roles = import ./src/roles;
            services = import ./src/services;
            users = import ./src/users;
            wireguard = import ./src/wireguard;
          };

          flakeRoot = ./.;
          specialArgs = { inherit inputs self flakeRoot; };
        in
        {
          imports = (builtins.attrValues flakeModules) ++ [
            inputs.lynx.flakeModules.builtins
            inputs.lynx.flakeModules.flake-guard
            inputs.asluni.flakeModules.asluni
            inputs.peridot.flakeModules.peridot
          ];

          config = {
            systems = [
              "x86_64-linux"
            ];

            flake = let
              hostList = builtins.attrNames config.flake.machines;
            in {
              # Debug
              _config = config;
              _options = options;

              inherit flakeModules flakeRoot;

              deploy.nodes = {
                fluorine = {
                  hostname = "192.168.1.17";
                  profiles.system = {
                    user = "root";
                    sshUser = "root";
                    sshOpts = [ "-T" ];
                    path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos config.flake.nixosConfigurations.fluorine;
                  };
                };
              };

              nixosConfigurations = genAttrs hostList (host: nixosSystem {
                specialArgs = specialArgs;
                modules = with config.flake; [
                  ./src/global.nix
                  machines.${host}
                  nixosModules.default
                  nixosModules.home-manager
                ];
              });

              # FIXME: broken
              homeConfigurations = mapAttrs (user: hostList:
                genAttrs hostList (host:
                  inputs.home-manager.lib.homeManagerConfiguration {
                    # TODO: Support other arch
                    pkgs = nixpkgs.legacyPackages.x86_64-linux;
                    extraSpecialArgs = specialArgs;
                    modules = [
                      config.flake.nixosModules.overlays
                      # Use the home-manager config from nixos.
                      config.flake.nixosConfigurations.${host}.config.home-manager.users.${user}
                    ];
                  }
                )
              ) config.homes;
            };
          };
        });

}
