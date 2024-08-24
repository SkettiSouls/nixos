{ stdenv, openjdk17_headless, unzip, fetchurl }:
let
  version = {
    pack = "0.7.11";
    minecraft = "1.20.1";
    forge = "47.2.6";
  };
in

stdenv.mkDerivation {
  name = "terrafirmagreg-server";

  forge = fetchurl {
    url = "https://maven.minecraftforge.net/net/minecraftforge/forge/${version.minecraft}-${version.forge}/forge-${version.minecraft}-${version.forge}-installer.jar";
    hash = "sha256-wcAmefWlttxo36zUulidZ/p2il5bMt/Oe+2qP3dUHbs=";
  };

  tfg = fetchurl {
    url = "https://github.com/TerraFirmaGreg-Team/Modpack-Modern/releases/download/${version.pack}/TerraFirmaGreg-1.20.x-${version.pack}-server.zip";
    hash = "sha256-TsijtuuwZN7f+8I/KZLTqsqC7UvP69c/p79eEF7XXcc=";
  };

  dontUnpack = true;

  # TODO: Ensure that the server starts if forge is installed.
  installPhase = ''
    mkdir -p $out/bin

    cat > $out/bin/minecraft-server << EOF
    #!/bin/sh
    cd /var/lib/minecraft

    if [ ! -d "/var/lib/minecraft/mods" ]; then
      cp -r "$tfg" terrafirmagreg.zip
      ${unzip}/bin/unzip -o terrafirmagreg.zip
      rm .minecraft/server.properties
      mv .minecraft/* .
      rm -r terrafirmagreg.zip .minecraft
    fi

    if [ ! -d "/var/lib/minecraft/libraries" ]; then
      cp "$forge" ./forge-installer-${version.forge}.jar
      exec ${openjdk17_headless}/bin/java -jar ./forge-installer-${version.forge}.jar --installServer
      exec ${openjdk17_headless}/bin/java \$@ -jar minecraft_server.jar nogui
    fi

    exec ${openjdk17_headless}/bin/java \$@ -jar minecraft_server.jar nogui
    EOF

    chmod +x $out/bin/minecraft-server
  '';
}
