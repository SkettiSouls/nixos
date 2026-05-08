{
  flake.modules.wrappers.bash =
    { config, wlib, lib, pkgs, ... }:
    {
      _file = ./bash.nix;
      imports = [ wlib.modules.default ];

      options = {
        bashrc = lib.mkOption {
          type = wlib.types.file {
            path = lib.mkOptionDefault config.constructFiles.bashrc.path;
          };
          default = {};
          description = ''
            The main bash configuration file.

            Provide either `.content` to inline file contents or `.path` to reference an existing file.
          '';
        };
      };

      config = {
        package = lib.mkDefault pkgs.bashInteractive;
        flags."--rcfile" = config.constructFiles.bashrc.path;

        constructFiles.bashrc = {
          relPath = "${config.binName}rc";
          content = config.bashrc.content;
        };
      };
    };
}
