{ inputs, ... }:
{
  flake.modules.services.minecraft =
    { pkgs, ... }:
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

      startForge = mc: forge: "java $JVMOPTS @libraries/net/minecraftforge/forge/${mc}-${forge}/unix_args.txt nogui";
    in {
      imports = [ inputs.nix-mc.nixosModules.nix-mc ];

      services = {
        nix-mc = {
          eula = true;
          instances = {
            TerraFirmaGreg = defaultConfig // {
              # Angry
              enable = false;
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
              startScript = startForge "1.20.1" "47.2.20";

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
              enable = false;
              startScript = startForge "1.18.2" "40.2.21";

              serverConfig = {
                level-name = "Euphamism";
                level-type = "tfc\:tng";
                motd = "[TerraFirmaCraft HardRock] She craft my rock till I'm hard";
                server-port = 25567;
              };
            };

            cabin = defaultConfig // {
              enable = false;
              jvmMaxAllocation = "16G";
              jarFile = "minecraft_server.jar";

              serverConfig = {
                allow-flight = true;
                level-name = "wah";
                level-type = "minecraft\:normal";
                motd = "[CABIN] Space? More like gayce am I right???";
                server-port = 25565;
              };
            };

            gtnh = defaultConfig // {
              enable = true;
              jvmMaxAllocation = "16G";
              startScript = "java -Xms6G -Xmx6G -Dfml.readTimeout=180 -Duser.language=en @java9args.txt -jar lwjgl3ify-forgePatches.jar nogui";

              serverConfig = {
                allow-flight = true;
                level-name = "guh";
                level-type="rwg";
                motd = "[GTNH] I'm greggin' my shit, I got tech on my shit";
                server-port = 25570;
              };
            };
          };
        };
      };
    };
}
