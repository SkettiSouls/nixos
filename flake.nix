{
  inputs = {
  # Base {{{
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wrapper-manager = {
      url = "github:viperML/wrapper-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  # }}}

  # Tools {{{
    bin = {
      url = "github:skettisouls/bin";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    neovim = {
      url = "git+https://codeberg.org/skettisouls/neovim";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs-unstable";
        utils.follows = "utils";
        wrapper-manager.follows = "wrapper-manager";
      };
    };

    polyphasia = {
      url = "git+https://codeberg.org/skettisouls/polyphasia";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        flake-parts.follows = "flake-parts";
        wrapper-manager.follows = "wrapper-manager";
      };
    };

    utils = {
      url = "git+https://codeberg.org/skettisouls/nix-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  # }}}

  # Hyprland {{{
    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/hyprland";
      submodules = true;
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "hyprland";
      inputs.hyprutils.follows = "hyprland";
    };
  # }}}

  # Discord {{{
    boris = { # Bot
      url = "github:skettisouls/boris";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        flake-parts.follows = "flake-parts";
      };
    };

    midnight-discord = {
      type = "git";
      url = "https://github.com/refact0r/midnight-discord";
      flake = false;
    };

    nixcord = {
      url = "git+https://codeberg.org/skettisouls/nixcord";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
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
  };

  outputs = inputs @ { nixpkgs, flake-parts, ... }: let
    # Extend `inputs.utils`, overlay that onto `lib`.
    utils = (import ./src/utils { inherit (nixpkgs) lib; inherit inputs; });
    specialArgs = {
      lib = nixpkgs.lib.extend (final: prev: utils);
    };
  in
  flake-parts.lib.mkFlake { inherit inputs specialArgs; }
  ({ lib, ... }: let
    flakeRoot = ./.;
    flakeModules = {
      hardware = import ./src/hardware;
      home-manager = import ./src/home-manager;
      machines = import ./src/machines;
      nixos = import ./src/nixos;
      overlays = import ./src/overlays;
      packages = import ./src/packages;
      roles = import ./src/roles;
      services = import ./src/services;
      users = import ./src/users;
      wireguard = import ./src/wireguard;
    };
  in {
    imports = (builtins.attrValues) flakeModules ++ [];

    config = {
      flake = { inherit flakeModules flakeRoot lib; };
      systems = [ "x86_64-linux" "aarch64-linux" ];
    };
  });
}
