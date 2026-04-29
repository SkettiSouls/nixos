{
  flake.modules.nixos.niri =
    { config, lib, pkgs, ... }:
    {
      options.programs.niri.withUWSM =
        lib.mkEnableOption "universal wayland session manager integration";

      config = {
        environment.systemPackages =
          lib.optionals config.programs.xwayland.enable
          [ pkgs.xwayland-satellite ];

        programs = {
          niri.enable = true;
          uwsm = lib.mkIf config.programs.niri.withUWSM {
            enable = true;
            waylandCompositors.niri = {
              prettyName = "Niri";
              comment = "Niri compositor managed by UWSM";
              binPath = "/run/current-system/sw/bin/niri-session";
            };
          };
        };
      };
    };
}
