{ ... }:
{ pkgs, ... }:

{
  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "72-pspad.rules";
      destination = "/etc/udev/rules.d/72-pspad.rules";
      text = ''
        # Disable PlayStation controller touchpad acting as mouse
        # USB
        ATTRS{name}=="Sony Interative Entertainment Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
        ATTRS{name}=="Sony Interative Entertainment DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"

        # Bluetooth
        ATTRS{name}=="Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
        ATTRS{name}=="DualSense Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
      '';
    })
  ];
}
