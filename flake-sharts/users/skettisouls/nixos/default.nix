perSystem@{ config }:
nixos@{ config, ... }:

{
  users.users.skettisouls = {
    home-manager.enable = true;
    wrapper-manager = {
      enable = true;
      installAll = false;

      packages = with perSystem.config.wrappedPackages; with skettisouls; [
        eza
        feishin
        # TODO: Fix gpg not having a pinentry
        # qutebrowser
      ];
    };
  };
}
