{
  flake.modules.hardware.gamepads =
    { config, lib, pkgs, ... }:
    let
      cfg = config.regolith.hardware.gamepads;
      tpamOption = lib.mkEnableOption "" // { description = "Allow the touchpad to act as mouse input"; };
      allTouchpadsAllowed = cfg.dualshock.touchpadAsMouse && cfg.dualsense.touchpadAsMouse;
    in {
      options.regolith.hardware.gamepads = {
        dualshock = lib.mkOption {
          default = {};
          description = "Options for the DualShock 4 Gamepad (PlayStation 4 Controller)";
          type = lib.types.submodule {
            options.touchpadAsMouse = tpamOption;
          };
        };

        dualsense = {
          default = {};
          description = "Options for the DualSense Gamepad (PlayStation 5 Controller)";
          type = lib.types.submodule {
            options.touchpadAsMouse = tpamOption;
          };
        };
      };

      config = {
        services.udev.packages = lib.optionals (!allTouchpadsAllowed) [
          (pkgs.writeTextFile {
            name = "72-pspad.rules";
            destination = "/etc/udev/rules.d/72-pspad.rules";
            text = lib.optionalString (!cfg.dualshock.touchpadAsMouse) ''
              # Disable DualShock 4 touchpad acting as mouse
              # USB
              ATTRS{name}=="Sony Interative Entertainment Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
              # Bluetooth
              ATTRS{name}=="Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
            '' + lib.optionalString (!cfg.dualsense.touchpadAsMouse) ''

              # Disable DualSense touchpad acting as mouse
              # USB
              ATTRS{name}=="Sony Interative Entertainment DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
              # Bluetooth
              ATTRS{name}=="DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
            '';
          })
        ];
      };
    };
}
