{ config, ... }:
let
  inherit (config) flake;
in
{
  flake.modules.bundles.desktop =
    { pkgs, ... }:
    {
      imports = with flake.modules.nixos; [
        display
        networking
        pipewire
      ];

      config = {
        environment.systemPackages = [ pkgs.keepassxc ];
      };
    };
}
