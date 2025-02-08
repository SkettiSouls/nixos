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

  config.home-manager = {
    extraSpecialArgs = { inherit inputs self host flakeRoot; };
    backupFileExtension = "bak";
    useGlobalPkgs = true;
    useUserPackages = true;
    users = mapAttrs (user: attrs: let
      inherit (attrs) home-manager machines;
      isEnabled = home-manager.enable && (lib.elem host machines);
    in {
      programs.home-manager.enable = mkIf isEnabled true;

      home = mkIf isEnabled rec {
        username = user;
        homeDirectory = lib.mkDefault "/home/${username}";
        stateVersion = config.system.stateVersion;
      };

      imports = lib.optionals isEnabled [
        homeModules.default
        home-manager.modules

        {
          options.roles = options.regolith.roles;
          config.roles = config.regolith.roles;
        }
      ];
    }) config.flake.users;
  };
}
