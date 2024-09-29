{ config, ... }:

{
  users.users.skettisouls = {
    home-manager.enable = true;
    wrapper-manager.enable = true;
  };
}
