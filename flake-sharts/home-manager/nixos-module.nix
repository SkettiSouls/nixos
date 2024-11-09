{ inputs, self, config, options, lib, ... }:
let
  inherit (config.flake)
    homeModules
    machines
    userModules
    ;

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
    extraSpecialArgs = { inherit inputs self; };
    backupFileExtension = "bak";
    useGlobalPkgs = true;
    useUserPackages = true;
    users = mapAttrs (user: attrs: let
      hm = attrs.home-manager;
    in
    {
      programs.home-manager.enable = mkIf hm.enable true;

      home = mkIf hm.enable (rec {
        username = user;
        homeDirectory = lib.mkDefault "/home/${username}";
        stateVersion = config.system.stateVersion;
      });

      imports = lib.optionals hm.enable [
        homeModules.default
        machines.homes.${user}.${host}
        userModules.${user}.home-manager

        {
          options.roles = options.shit.roles;
          config.roles = config.shit.roles;
        }
      ];
    }) config.flake._config.users;
  };
}
