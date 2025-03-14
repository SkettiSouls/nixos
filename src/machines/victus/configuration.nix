{ self, lib, pkgs,  ... }:

{
  roles = with self.roles; [
    desktop
    gaming
    workstation
  ];

  networking.hostName = "victus"; # Define your hostname.
  # TODO: See if wpa_supplicant is required for declaring wifi connections.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  programs = {
    # Required for xwayland to work, despite being enabled by hyprland.
    xwayland.enable = true;
  };

  # TODO: Research
  # hardware = {
  #   enableRedistributableFirmware = true;
  # };

  # TODO: Setup wireguard
  wireguard = {
    luni-net.enable = false;
    peridot.enable = false;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
