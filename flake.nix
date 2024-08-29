{
  inputs = {
  # Base {{{
    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  # }}}

  # Discord {{{
    midnight-discord = {
      type = "git";
      url = "https://github.com/refact0r/midnight-discord";
      flake = false;
    };

    nixcord = {
      url = "github:skettisouls/nixcord";
      inputs.nixpkgs.follows = "vesktop";
    };

    # Allow updating vesktop independent of nixpkgs-unstable
    vesktop.url = "github:NixOS/nixpkgs/nixos-unstable";
  # }}}

  # Hyprland {{{
    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/hyprland";
      submodules = true;
    };

    hyprpicker.url = "github:hyprwm/hyprpicker";
  # }}}

  # Dev {{{
    bin = {
      type = "git";
      url = "file:/etc/nixos/flake-sharts/packages/scripts?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    neovim = {
      type = "git";
      url = "file:/etc/nixos/flake-sharts/packages/neovim?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  # }}}

  # Server {{{
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-mc.url = "github:skettisouls/nix-mc";
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

            home-manager.imports = [
              ./flake-sharts/home-manager
              ./flake-sharts/home-manager/nixos-module.nix
            ];

            hosts = import ./flake-sharts/hosts;
            hyprland = import ./flake-sharts/hyprland;
            libs = import ./flake-sharts/libs;
            nixos = import ./flake-sharts/nixos;
            packages = import ./flake-sharts/packages;
            river = import ./flake-sharts/river;
            roles = import ./flake-sharts/roles;
            services = import ./flake-sharts/services;
            users = import ./flake-sharts/users;
            wireguard = import ./flake-sharts/wireguard;
          };

          hm-module = (builtins.head config.flake.nixosModules.home-manager.imports);
          specialArgs = { inherit inputs self; };
        in
        {
          imports = (builtins.attrValues flakeModules) ++ [
            inputs.lynx.flakeModules.builtins
            inputs.lynx.flakeModules.flake-guard
            inputs.asluni.flakeModules.asluni
            inputs.peridot.flakeModules.peridot
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

              nixosConfigurations = genAttrs config.machines (host: nixosSystem {
                specialArgs = specialArgs // { currentMachine = host; };
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
                    extraSpecialArgs = specialArgs;
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
