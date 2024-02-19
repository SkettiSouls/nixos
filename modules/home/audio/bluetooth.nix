{ config, lib, pkgs, ... }:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.shit.bluetooth;
in
{
  options.shit.bluetooth = {
    enable = mkEnableOption "User bluetooth config.";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ ];
    home.file =  {
      ".config/wireplumber/policy.lua.d/11-bluetooth-policy.lua".text = ''
      -- Disable bluetooth codec switching
      bluetooth_policy.policy["media-role.use-headset-profile"] = false '';
    };
  };
}
