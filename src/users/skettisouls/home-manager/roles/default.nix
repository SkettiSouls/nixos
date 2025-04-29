{ lib, ... }:

{
  imports = lib.getModules ./.;

  options.roles = {
    desktop.enable = lib.mkEnableOption "Desktop role check";
    gaming.enable = lib.mkEnableOption "Gaming role check";
    workstation.enable = lib.mkEnableOption "Workstation role check";
  };
}
