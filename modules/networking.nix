{
  flake.modules.nixos.networking =
    { lib, ... }:
    {
      networking.networkmanager.enable = lib.mkDefault true;
      systemd.services.NetworkManager-wait-online.enable = lib.mkDefault false;

      services.openssh.enable = lib.mkDefault true;
    };
}
