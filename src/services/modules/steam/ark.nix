{ config, lib, pkgs, ... }:
{
  services.steam-dedicated.ark = {
    enable = true;
    port = 7777;
    appId = 376030;

    serviceConfig.WorkingDirectory = "/var/lib/ark/ShooterGame/Binaries/Linux";

    # TODO: Write config files in ExecStartPre
    startCmd = ''
      ${pkgs.steam-run}/bin/steam-run ./ShooterGame/Binaries/Linux/ShooterGameServer \
      Fjordur?listen?RCONEnabled=true?RCONPort=27020?ServerAdminPassword=123 \
      -NoBattlEye \
      -NotifyAdminCommandsInChat \
      -server \
      -log
    '';
  };
}
