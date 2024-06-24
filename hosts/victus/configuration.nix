{ inputs, config, pkgs, lib, ... }:
let
  internalMonitor = config.shit.hardware.laptop.internalMonitor;
  lidSwitch = config.shit.hardware.laptop.lidSwitch;
in
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

  shit.users.skettisouls = true;

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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs = {
    dconf.enable = true;
    # Required for xwayland to work, despite being enabled by hyprland.
    xwayland.enable = true;
  };

  # TODO: Research
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
      laptop.lidSwitch = "1fae3b0";
    };

    home-manager = {
      enable = true;
      users = {
        skettisouls = import ./home.nix;
      };
    };
  };

  home-manager.users = lib.mapAttrs
  (name: value: {
    # Set default system wallpaper and monitor settings.
    shit = {
      hyprland = lib.mkDefault {
        monitors."${internalMonitor}".refreshRate = "144";
        wallpapers = {
          nixos = {
            monitors = [ internalMonitor ];
            source = "/etc/nixos/shit/images/wallpapers/nixos-frappe.png";
          };
        };
      };
    };

    # Set hardware specifics (i.e. fn keys, closing/opening events)
    wayland.windowManager.hyprland.settings = {
      # TODO: Make close suspend and open wake up. (saves power)
      # Turn monitor off and on when closing and opening the lid respectively.
      bindl = [
        # ",switch:${lidSwitch},exec,hyprlock" # Toggle
        '',switch:on:${lidSwitch},exec,hyprctl keyword monitor "${internalMonitor}, disable"'' # Close
        '',switch:${lidSwitch},exec,hyprctl keyword monitor "${internalMonitor}, 1920x1080, 0x0, 1"'' # Open

        '', XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'' # FN + F5
      ];

      bindel = [
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-" # FN + F6
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+" # FN + F7
      ];

      bind = [
        ", XF86MonBrightnessUp, exec, brightnessctl s +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"
      ];
    };
  }) config.shit.home-manager.users;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
