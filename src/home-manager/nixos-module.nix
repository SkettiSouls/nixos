{ inputs, self, flakeRoot, config, lib, ... }:
let
  inherit (lib) mapAttrs;
  inherit (config.flake) homeModules;

  host = config.networking.hostName;
  users = lib.filterAttrs (_: v: v.isNormalUser) config.users.users;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  config.home-manager = {
    extraSpecialArgs = { inherit inputs self host flakeRoot; };
    backupFileExtension = "bak";
    useGlobalPkgs = true;
    # Move packages from $HOME/.nix-profile to /etc/profiles/
    # useUserPackages = true; # Causes infinite recursion when accessing users.users
    users = mapAttrs (user: _: {
      imports = lib.combineModules homeModules;

      programs.home-manager.enable = true;

      home = rec {
        username = user;
        homeDirectory = lib.mkDefault "/home/${username}";
        stateVersion = config.system.stateVersion;
      };
    }) users;
  };
}
