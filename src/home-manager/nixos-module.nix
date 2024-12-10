{ inputs, self, flakeRoot, config, options, lib, ... }:
let
  inherit (config.flake) homeModules;

  inherit (lib)
    mapAttrs
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  host = config.networking.hostName;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.users.users = mkOption {
    type = with types; attrsOf (submodule {
      options.home-manager.enable = mkEnableOption "Manage user configs with home-manager";
    });
  };

  config.home-manager = {
    extraSpecialArgs = { inherit inputs self host flakeRoot; };
    backupFileExtension = "bak";
    useGlobalPkgs = true;
    useUserPackages = true;
    users = mapAttrs (user: attrs: let
      inherit (attrs) home-manager;
    in
    {
      programs.home-manager.enable = mkIf home-manager.enable true;

      home = mkIf home-manager.enable (rec {
        username = user;
        homeDirectory = lib.mkDefault "/home/${username}";
        stateVersion = config.system.stateVersion;
      });

      imports = lib.optionals home-manager.enable [
        homeModules.default
        home-manager.modules

        {
          options.roles = options.shit.roles;
          config.roles = config.shit.roles;
        }
      ];
    }) config.flake.users;
  };
}
