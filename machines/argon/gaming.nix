{ config, ... }:
{
  flake.machines.argon.modules = [(
    { lib, pkgs, ... }:
    {
      imports = [ config.flake.modules.nixos.steam ];
      config = {
        boot.initrd.kernelModules = [ "ntsync" "hid-universal-pidff" ];
        nixpkgs.config.permittedInsecurePackages = [ "nexusmods-app-0.21.1" ];

        environment.systemPackages = with pkgs; [
          boxflat
          heroic
          prismlauncher
          unstable.wineWow64Packages.staging
          winetricks
        ];

        services.udev.packages = [
          pkgs.boxflat
          # Attempt to fix games not finding my wheel
          (pkgs.writeTextFile {
            name = "90-moza-fix.rules";
            destination = "/etc/udev/rules.d/90-moza-fix.rules";
            text = ''
              KERNEL=="hidraw*", ATTRS{idVendor}=="346e", ATTRS{idProduct}=="0004", MODE="0666"
            '';
          })
        ];

        hardware.graphics = {
          package = lib.mkForce pkgs.unstable.mesa;
          package32 = lib.mkForce pkgs.unstable.driversi686Linux.mesa;
        };

        programs = {
          appimage = {
            enable = true;
            package = pkgs.appimage-run.override {
              extraPkgs = pkgs: [ pkgs.icu ];
            };
          };

          steam = {
            extraCompatPackages = with pkgs; [ steamtinkerlaunch ];

            proton-ge = {
              enable = true;
              package = pkgs.unstable.proton-ge-bin;
            };

            package = pkgs.steam.override {
              extraEnv = {
                # TODO 7: Make steam user mangohud wrapper
                MANGOHUD = true;
                # Used for obs vulkan capture plugin
                OBS_VKCAPTURE = true;
              };
            };
          };
        };
      };
    }
  )];
}
