{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.shit.fetch.neofetch;
in
{
  imports = [ ./trollos.nix ];

  options.shit.fetch.neofetch = {
    enable = mkEnableOption "Neofetch user configuration";
    showHost = mkEnableOption "Show motherboard info";

    image = {
      # Must be set for non-ascii images
      renderer = mkOption {
        type = types.str;
        default = "ascii";
      };

      source = mkOption {
        type = with types; nullOr (either str path);
        default = null;
      };

      size = mkOption {
        type = types.str;
        default = "auto";
      };
    };

    distroName = mkOption {
      type = types.nullOr types.str;
      default = null;
    };

    asciiColors = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [pkgs.neofetch];
    # TODO: Find a way to shorten Host
    home.file.".config/neofetch/config.conf".text = ''
      print_info() {
        info title
        info underline

        ${if (cfg.distroName != null) then (''distro="${cfg.distroName}"'') else ""}
        info "OS" distro
        # info "Host" model # Too long, collides with images.
        ${if cfg.showHost then (''info "Host" model'') else ""}
        info "Kernel" kernel
        info "Uptime" uptime
        info "Packages" packages
        info "Shell" shell
        # info "Resolution" resolution
        info "DE" de
        info "WM" wm
        info "WM Theme" wm_theme
        info "Theme" theme
        info "Icons" icons
        info "Terminal" term
        info "Terminal Font" term_font
        info "CPU" cpu
        info "GPU" gpu
        info "Memory" memory

        # info "GPU Driver" gpu_driver  # Linux/macOS only
        # info "Disk" disk
        # info "Battery" battery
        # info "Font" font
        # info "Song" song
        # [[ "$player" ]] && prin "Music Player" "$player"
        # info "Users" users
        # info "Locale" locale  # This only works on glibc systems.

        info cols
      }

      image_backend=${cfg.image.renderer}
      image_size=${cfg.image.size}

      ${if (cfg.asciiColors != null) then ("ascii_colors=(${cfg.asciiColors})") else ""}
      ${if (cfg.image.source != null) then ("image_source=${cfg.image.source}") else ""}
    '';
  };
}
