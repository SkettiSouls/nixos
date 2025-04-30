{ pkgs, ... }:

{
  config = {
    networking.networkmanager.enable = true;
    systemd.services.NetworkManager-wait-online.enable = false;

    services = {
      openssh.enable = true;
      udisks2.enable = true;
    };

    programs = {
      # Mutually exclusive with nix-index, and depends on channels
      command-not-found.enable = false;

      nix-index = {
        enable = true;
        enableBashIntegration = true;
      };

      direnv = {
        enable = true;
        silent = true;
      };
    };

    environment.systemPackages = with pkgs; [
      btop
      comma
      devenv
      fzf
      neovim
      unzip
      zip
    ];

    # TODO: Switch to Iosevka
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      nerd-fonts.sauce-code-pro
      nerd-fonts.dejavu-sans-mono
    ];
  };
}
