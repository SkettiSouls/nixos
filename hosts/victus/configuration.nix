{ inputs, config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  roles = {
    desktop.enable = true;
    gaming.enable = true;
    workstation.enable = true;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "victus"; # Define your hostname.
  # TODO: See if wpa_supplicant is required for declaring wifi connections.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.skettisouls = {
    isNormalUser = true;
    description = "skettisouls";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs = {
    dconf.enable = true;
    xwayland.enable = true;
  };

  # hardware = {
  #   enableRedistributableFirmware = true;
  # };

  shit = {
    pipewire.enable = true;
    # TODO: Add to luni-net.
    wireguard.enable = lib.mkForce false;

    hardware = {
      bluetooth.enable = true;
      nvidia.enable = true;
    };

    home-manager = {
      enable = true;
      users = {
        skettisouls = import ./home.nix;
      };
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
