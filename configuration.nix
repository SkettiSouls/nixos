# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/system
      ./overlays.nix
    ];

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_6_8;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "goatware"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";


  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    (nerdfonts.override { fonts = [ "SourceCodePro" "DejaVuSansMono" ]; })
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.skettisouls = {
    isNormalUser = true;
    description = "skettisouls";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      gnome.nautilus
      prismlauncher
      lutris
      wineWowPackages.staging
      winetricks
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    comma
    cloudflare-warp
    home-manager
    neovim
    fzf
    eza
    rsync
    zip
    unzip
    appimage-run
    linuxKernel.kernels.linux_6_8
    btop
    pavucontrol
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  services = {
    udisks2 = {
      enable = true;
    };

    xserver = {
      enable = true;
      layout = "us";
      xkbVariant = "";
      displayManager.lightdm.enable = lib.mkForce false;
    };

  };

  security = {
    polkit.enable = true;
  };

  programs = {
    dconf.enable = true;
    xwayland.enable = true;
  };

  hardware = {
    enableRedistributableFirmware = true;
  };
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  shit = {
    pipewire.enable = true;
    hardware = {
      cpu.enable = true;
      gpu.enable = true;
      fstab.enable = true;
      bluetooth.enable = true;
    };
    applications = {
      steam.enable = true;
    };
  };

  /* Doesn't work
    # mtwk's weird mouse fix or w/e
    MatchUdevType=mouse;
    ModelBouncingKeys=1;
  */

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
