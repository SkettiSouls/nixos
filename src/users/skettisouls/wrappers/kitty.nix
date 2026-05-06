{ config, ... }:
{
  flake.users.skettisouls = config.flake.lib.perSystem
  ({ wlib, pkgs, ... }:
  {
    wrappers.kitty = wlib.wrapPackage {
      imports = [ wlib.wrapperModules.kitty ];

      config = {
        inherit pkgs;
        package = pkgs.unstable.kitty;
        font.name = "DejaVu Sans Mono";

        settings = {
          editor = "nvim";
          scrollback_lines = 10000;
          background_opacity = 0.8;
          update_check_interval = 0;

          ### Tab Bar ###
          tab_bar_edge = "bottom";
          tab_bar_style = "powerline";
          tab_bar_min_tabs = 2;
          tab_switch_strategy = "previous";
          tabe_fade = "0.25 0.5 0.75 1"; # Play around with this.
          tab_powerline_style = "angled";
          tab_title_template = "{index}";
        };
      };
    };
  });
}
