{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/nixos
    ];

  roles = {
    server.enable = true;
    workstation.enable = true;
  };

  shit.users.skettisouls.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "fluorine";

  users.users.skettisouls.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHAV0a5O5FiI6ApGw0C+9lWWi0WQvYNivNkcwp3owwfz"
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHAV0a5O5FiI6ApGw0C+9lWWi0WQvYNivNkcwp3owwfz"
  ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "America/Chicago";

  nix.settings = {
    trusted-users = [
      "skettisouls"
    ];
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "24.05";

  home-manager.sharedModules = [{
    programs.home-manager.enable = true;
    home.stateVersion = "24.05";
  }];
}
