{
  flake.modules.wrappers.wpaperd =
    { config, wlib, pkgs, lib, ... }:
    let
      tomlFormat = pkgs.formats.toml {};
    in {
      _file = ./wpaperd.nix;
      imports = [ wlib.modules.default ];

      options = {
        settings = lib.mkOption {
          default = {};
          type = tomlFormat.type;
          example = lib.literalExpression ''
            {
              HDMI-A-1 = {
                path = "/home/foo/Pictures/Wallpapers";
                apply-shadow = true;
                sorting = descending;
              };
            }
          '';
          description = ''
            Configuration to wrap wpaperd with.
            See <https://github.com/danyspin97/wpaperd#wallpaper-configuration>.
          '';
        };

        "config.toml" = lib.mkOption {
          type = wlib.types.file {
            path = lib.mkOptionDefault config.constructFiles.configFile.path;
          };
          default = {};
          description = ''
            Configuration file for wpaperd.
            See <https://github.com/danyspin97/wpaperd#wallpaper-configuration>.

            If `.content` is non-empty, its content will be used instead of the generated
            config from `config.settings` in the generated config file in the derivation.

            You may also set `.path` to source an external config file.
            This will still output a config file generated from `config.settings`.
          '';
        };

        systemd = {
          enable = lib.mkEnableOption "" // {
            description = "Whether to include systemd service setup";
          };

          hotReloadConfig = lib.mkEnableOption "" // {
            default = true;
            description = ''
              When `false`, the wrapper will not hot reload wpaperd with the new config on rebuild.
            '';
          };
        };
      };

      config = lib.mkMerge [
        {
          package = pkgs.wpaperd;
          flags."--config" = config."config.toml".path;

          constructFiles.configFile = {
            relPath = "${config.binName}-config.toml";
            content =
              if config."config.toml".content != ""
              then config."config.toml".content
              else lib.readFile (tomlFormat.generate "wpaperd-config" config.settings);
          };
        }

        (lib.mkIf config.systemd.enable {
          constructFiles.serviceFile = {
            relPath = "share/systemd/user/wpaperd.service";
            content = ''
              [Unit]
              Description=Modern wallpaper daemon for Wayland
              PartOf=graphical-session.target
              After=graphical-session.target

              [Service]
              ExecStart=${config.wrapperPaths.placeholder}
              Restart=always
              RestartSec=10
            '';
          };

          buildCommand.wpaperdReloadConfig = lib.mkIf config.systemd.hotReloadConfig {
            after = [ "symlinkScript" ];
            data = ''
              chmod +w ${placeholder config.outputName}/share/systemd/user/wpaperd.service
              cat >> ${placeholder config.outputName}/share/systemd/user/wpaperd.service<<EOF
              [Unit]
              X-Reload-Triggers=${config.constructFiles.configFile.path}
              [Service]
              X-ReloadIfChanged=true
              EOF
            '';
          };
        })
      ];
    };
}
