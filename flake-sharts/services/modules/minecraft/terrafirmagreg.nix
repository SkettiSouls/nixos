{ inputs, pkgs, ... }:

{
  imports = [ inputs.minix.nixosModules.minix ];

  services = {
    minix = {
      eula = true;
      instances = {
        TerraFirmaGreg = {
          enable = true;
          jvmPackage = pkgs.temurin-bin-17;
          jvmMaxAllocation = "12288M";
          jvmInitialAllocation = "3072M";

          serverConfig = {
            allow-flight = true;
            allow-nether = false;
            difficulty = 3;
            level-name = "Monkey Men";
            max-players = 10;
            motd = "[TerraFirmaGreg 1.20.1] Zeke likes balls.";
            online-mode = false; # Allowed cracked clients.
            player-idle-timeout = 15;
            server-port = 25565;
            snooper-enabled = false;
            spawn-protection = 0;
            view-distance = 8;
          };
        };
      };
    };
  };
}
