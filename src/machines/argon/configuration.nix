{ self, lib, pkgs, ... }:

{
  roles = with self.roles; [
    desktop
    gaming
    workstation
  ];

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  networking = {
    hostName = "argon";
    networkmanager.enable = true;
  };
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";


  # Enable networking
  systemd.services.NetworkManager-wait-online.enable = false;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    appimage-run
    cloudflare-warp
    pavucontrol
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # TODO: Find a way to move this to hm
  services = {
    flatpak.enable = true;
  };

  programs = {
    dconf.enable = true;
    xwayland.enable = true;
  };

  hardware = {
    enableRedistributableFirmware = true;
  };

  # Needed for flatpak support
  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
    ];
  };

  regolith = {
    pipewire.enable = true;
  };

  /* Doesn't work
    # mtwk's weird mouse fix or w/e
    MatchUdevType=mouse;
    ModelBouncingKeys=1;
  */

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
