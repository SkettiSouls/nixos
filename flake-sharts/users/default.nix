{
  config.flake.nixosModules = {
    users = import ./modules/users.nix;
  };

  config.flake.userModules = {
    skettisouls = ./modules/skettisouls.nix;
  };
}
