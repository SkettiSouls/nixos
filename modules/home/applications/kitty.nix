{ config, lib, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.shit.kitty;
in
{
  options.shit.kitty = {
    enable = mkEnableOption "Kitty user configuration";
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      font.name = "DejaVu Sans Mono";

      shellIntegration = {
        enableBashIntegration = true;
      };

      settings = {
        scrollback_lines = 10000;
        background_opacity = "0.8";
        linux_display_server = "wayland";
        editor = "nvim";
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
}
