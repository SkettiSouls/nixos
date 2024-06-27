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

  outputs = inputs @ { self, nixpkgs, home-manager, flake-parts, lynx, asluni, ... }:
    flake-parts.lib.mkFlake { inherit inputs; }
      (args @ { config, options, flake-parts-lib, ... }:
        let
          inherit (flake-parts-lib) importApply;

          inherit (nixpkgs.lib)
            mapAttrs
            mkOption
            nixosSystem
            types
            ;

          mapHosts = map (host: { ${host} = ./hosts/${host}/configuration.nix; });
          delist = builtins.foldl' (acc: attrs: acc // attrs) {};

          flakeModules = {
            # features = importApply ./flake-sharts/features args;
            hardware = importApply ./flake-sharts/hardware args;
            # home-manager = importApply ./flake-sharts/home-manager args;
            # hosts = importApply ./flake-sharts/hosts args;
            libs = importApply ./flake-sharts/libs args;
            nixos = importApply ./flake-sharts/nixos args;
            packages = importApply ./flake-sharts/packages args;
            # roles = importApply ./flake-sharts/roles args;
            users = importApply ./flake-sharts/users args;
            wireguard = importApply ./flake-sharts/wireguard args;
          };
        in
        {
          imports = with flakeModules; [
            hardware
            libs
            nixos
            packages
            users
            wireguard

            inputs.lynx.flakeModules.flake-guard
            inputs.asluni.flakeModules.asluni
          ];

          options = {
            nixos = mkOption { type = with types; attrsOf unspecified; };
            home = mkOption { type = with types; attrsOf unspecified; };
          };

          config = {
            systems = [
              "x86_64-linux"
            ];

            nixos = delist (mapHosts [
              "argon"
              "fluorine"
              "victus"
            ]);

            # TODO: Switch to `skettisouls = [ argon fluorine victus ]` structure.
            home = {
              "skettisouls@argon" = ./flake-sharts/homes/skettisouls/argon.nix;
              "skettisouls@fluorine" = ./flake-sharts/homes/skettisouls/fluorine.nix;
              "skettisouls@victus" = ./flake-sharts/homes/skettisouls/victus.nix;
            };

            flake = {
              _config = config;
              _options = options;

              inherit flakeModules;

              nixosConfigurations = mapAttrs (hostName: configFile: nixosSystem {
                specialArgs = { inherit inputs self; };
                modules = [
                  configFile
                  ./global.nix
                  ./roles
                  ./overlays.nix
                  config.flake.nixosModules.default
                  config.flake.userModules.default
                ];
              }) config.nixos;

              # FIXME: Infinite recursion.
              homeConfigurations = mapAttrs (name: value: home-manager.lib.homeManagerConfiguration {
                pkgs = nixpkgs.legacyPackages.x86_64-linux;
                modules = [
                  value
                  ./overlays.nix
                ];
              }) config.home;
            };
          };
        });

}
