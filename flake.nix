{
  inputs = {
  # Base {{{
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    wrapper-modules = {
      url = "github:BirdeeHub/nix-wrapper-modules";
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

  # Server {{{
    boris = { # Discord Bot
      url = "github:skettisouls/boris";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        flake-parts.follows = "flake-parts";
        rust-overlay.follows = "rust-overlay";
      };
    };

    nix-mc = {
      url = "github:skettisouls/nix-mc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  # }}}
  };

  outputs = inputs @ { flake-parts, nixpkgs, import-tree, ... }: let
    inherit (nixpkgs) lib;

    flakeRoot = ./.;
    tree = (lib.pipe import-tree [
      (i: i.filterNot (lib.hasInfix "/packages/"))
      (i: i.filterNot (lib.hasSuffix "flake.nix"))
      (i: i ./.)
    ]).imports;
  in
  flake-parts.lib.mkFlake { inherit inputs; } ({ config, ... }: {
    imports = tree ++ [ ./packages ];

    config = {
      systems = [ "x86_64-linux" "aarch64-linux" ];

      flake = {
        inherit flakeRoot;
        _config = config;
      };
    };
  });
}
