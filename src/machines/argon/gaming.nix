{ config, ... }:
{
  flake.machines.argon.modules = [(
    { lib, pkgs, ... }:
    {
      imports = [ config.flake.modules.nixos.steam ];
      config = {
        nixpkgs.config.permittedInsecurePackages = [ "nexusmods-app-0.21.1" ];

        environment.systemPackages = with pkgs; [
          heroic
          prismlauncher
          unstable.wineWow64Packages.staging
          winetricks
        ];

        hardware.graphics = {
          package = lib.mkForce pkgs.unstable.mesa;
          package32 = lib.mkForce pkgs.unstable.driversi686Linux.mesa;
        };

        programs.steam = {
          extraCompatPackages = with pkgs; [ steamtinkerlaunch ];

          proton-ge = {
            enable = true;
            package = pkgs.unstable.proton-ge-bin;
          };

          package = pkgs.steam.override {
            extraEnv = {
              MANGOHUD = true;
              # Used for obs vulkan capture plugin
              OBS_VKCAPTURE = true;
            };
          };
        };
      };
    }
  )];
}
