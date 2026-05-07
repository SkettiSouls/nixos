{
  perSystem = { pkgs, ... }: let
    inherit (pkgs) lib;
    # TODO: Test if this works with multifile configs
    wrapQuickshell = name: path: pkgs.writeShellScriptBin "quickshell-${name}" ''
      is_running() {
        [ -n "$(${pkgs.unstable.quickshell}/bin/quickshell list -p ${path} | grep Process)" ]
      }

      if [ -n "$1" ]; then
        case $1 in
          -d | --die)
            ${pkgs.unstable.quickshell}/bin/quickshell kill -p ${path}
            ;;

          -c | --check)
            if is_running; then
              echo true
            else
              echo false
            fi
            ;;

          -p | --path)
            echo ${path}
            ;;

          -h | --help)
            echo -e "quickshell-${name} [OPTIONS]\n"
            echo "OPTIONS:"
            echo "  -h,    --help       Print this message"
            echo "  -d,    --die        Kill the instance"
            echo "  -c,    --check      Check if the instance is running."
            echo "  -p,    --path       Print the nix store path of the config"
            ;;
          *)
            echo "Invalid option: $1" >&2
            exit 1
            ;;
        esac
      elif !(is_running); then
        ${pkgs.unstable.quickshell}/bin/quickshell -p ${path}
      fi
    '';
  in {
    packages = lib.mapAttrs' (k: v: {
      name = "quickshell-${k}";
      value = wrapQuickshell k v;
    }) {
      mute-osd = ./mute-osd.qml;
    };
  };
}
