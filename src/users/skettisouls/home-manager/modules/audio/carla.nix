{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.shit.audio.carla;
in
{
  options.shit.audio.carla = {
    enable = mkEnableOption "Carla user configuration";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      rnnoise-plugin
    ];

    programs.carla = {
      enable = true;
      settings = {
        General = {
          ShowKeyboard = false;
          ShowMeters = true;
          ShowSidePanel = true;
          ShowToolbar = true;
        };
        Canvas = {
          Antialiasing = "1";
          AutoHideGroups = true;
          AutoSelectItems = false;
          EyeCandy2 = true;
          FancyEyeCandy = false;
          FullRepaints = true;
          HQAntialising = false;
          InlineDisplays = true;
          Size = "3100x2400";
          Theme = "Modern Dark";
          UseBezierLines = true;
          UseOpenGL = false;
        };

        Engine = {
          AudioDriver = "JACK";
          ForceStereo = false;
          ManageUIs = true;
          MaxParameters = "200";
          PreferPluginBridges = false;
          ProcessMode = "0"; # 0 = Single Client, 1 = Multi Client, 2 = Continuous Rack, 3 = Patchbay
          ResetXruns = false;
          # Transport Extra # literally cant find this setting
          TransportMode = "1";
          UIsAlwaysOnTop = true;
          UiBridgesTimeout = "4000";
        };

        Experimental = {
          ExportLV2 = false;
          JackApplications = false;
          LoadLibGlobal = false;
          PluginBridges = false;
          PreventBadBehaviour = false;
          WineBridges = false;
        };

        Main = {
          ClassicSkin = false;
          ConfirmExit = true;
          Experimental = false;
          ProThemeColor = "Black";
          RefreshInterval = "20";
          ShowLogs = true;
          SystemIcons = true;
          UseProTheme = true;
        };
        /* No clue what this is, needs research
        OSC = {
          Enabled = true;
          TCPEnabled = true;
          TCPNumber = "22752";
          TCPRandom = false;
          UDPEnabled = true;
          UDPNumber = 22752;
          UDPRandom = false;
        };
        */

        Wine = {
          AutoPrefix = true;
          BaseRtPrio = "15";
          Executable = "wine";
          FallbackPrefix = "${config.home.homeDirectory}/.wine";
          RtPrioEnabled = true;
          ServerRtPrio = 10;
        };
      };
      paths = {
        folders = [ /etc/nixos/etc/carla ];
        projectFolder = "/etc/nixos/etc/carla";
        ladspa = [
          "${pkgs.rnnoise-plugin}/lib"
        ];
      };
    };
  };
}
