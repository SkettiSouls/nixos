{
  inputs = {
  # Base {{{
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
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
        rust-overlay.follows = "rust-overlay";
      };
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
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
        rust-overlay.follows = "rust-overlay";
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

  outputs = inputs @ { flake-parts, ... }: let
    inherit (flake-parts.lib) importApply;
    flakeRoot = ./.;

    lib = import ./src/utils { inherit inputs; };
    withArgs = file: args:
      importApply file
      ({
        inherit inputs flakeRoot withArgs;
        lib = lib.extend (final: prev: {
          applyModules = src:
            map
            (file: withArgs file {})
            (prev.getModules src);
        });
      } // args);
  in
  flake-parts.lib.mkFlake { inherit inputs; }
  (let
    flakeModules = {
      hardware = import ./src/hardware;
      home-manager = withArgs ./src/home-manager {};
      lib = { config.flake = { inherit lib; }; };
      machines = withArgs ./src/machines {};
      nixos = withArgs ./src/nixos {};
      packages = import ./src/packages;
      roles = import ./src/roles;
      services = withArgs ./src/services {};
      shells = withArgs ./src/shells {};
      users = withArgs ./src/users {};
      wireguard = import ./src/wireguard;
    };
  in {
    imports = (builtins.attrValues) flakeModules ++ [];

    config = {
      flake = { inherit flakeModules flakeRoot; };
      systems = [ "x86_64-linux" "aarch64-linux" ];
    };
  });
}
