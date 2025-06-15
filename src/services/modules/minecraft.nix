{ inputs, pkgs, ... }:
let
  defaultConfig = {
    jvmPackage = pkgs.temurin-bin-17;
    jvmMaxAllocation = "8G";
    jvmInitialAllocation = "2G";

    serverConfig = {
      allow-flight = true;
      difficulty = 3;
      online-mode = false; # Allow cracked clients
      player-idle-timeout = 15;
      snooper-enabled = false;
      spawn-protection = 0;
      view-distance = 10;
    };
  };
in
{
  imports = [ inputs.nix-mc.nixosModules.nix-mc ];

  services = {
    nix-mc = {
      eula = true;
      instances = {
        TerraFirmaGreg = defaultConfig // {
          enable = true;
          jarFile = "minecraft_server.jar";

          serverConfig = {
            allow-nether = false;
            level-name = "Monkey Men";
            level-type = "tfc\:overworld";
            motd = "[TerraFirmaGreg 1.20.1] Make rocks think";
            server-port = 25565;
            view-distance = 8;
          };
        };

        atm9sky = defaultConfig // {
          # Finished
          enable = false;
          startScript = "java $JVMOPTS @libraries/net/minecraftforge/forge/1.20.1-47.2.20/unix_args.txt nogui";

          serverConfig = {
            level-name = "Baby Men";
            level-type = ''skyblockbuilder:skyblock'';
            motd = "[All The Mods 9: To the Sky] Totally not skyfactory";
            server-port = 25567;
          };
        };

        steampunk = defaultConfig // {
          # Nobody else wants to play :(
          enable = false;

          serverConfig = {
            level-name = "Gearheads";
            level-type = "default";
            motd = "[SteamPunk] Get rotated loser";
            server-port = 25567;
          };
        };

        hardrock = defaultConfig // {
          enable = true;
          startScript = "java $JVMOPTS @libraries/net/minecraftforge/forge/1.18.2-40.2.21/unix_args.txt nogui";

          serverConfig = {
            level-name = "Euphamism";
            level-type = "tfc\:tng";
            motd = "[TerraFirmaCraft HardRock] She craft my rock till I'm hard";
            server-port = 25567;
          };
        };
      };
    };
  };
}
