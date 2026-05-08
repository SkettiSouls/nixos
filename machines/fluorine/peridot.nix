{
  flake.machines.fluorine.modules = [
    ({ pkgs, ... }:
    let
      iptables = "${pkgs.iptables}/bin/iptables";
    in {
      networking.wireguard.interfaces.peridot = {
        ips = [ "192.168.10.1/24" ];
        postSetup =
          "${iptables} -A FORWARD -i %i -j ACCEPT; " +
          "${iptables} -A FORWARD -o %i -j ACCEPT; " +
          "${iptables} -t nat -A POSTROUTING -o eno1 -j MASQUERADE";
        postShutdown =
          "${iptables} -D FORWARD -i %i -j ACCEPT; " +
          "${iptables} -D FORWARD -o %i -j ACCEPT; " +
          "${iptables} -t nat -D POSTROUTING -o eno1 -j MASQUERADE";
      };
    })
    ({ config, lib, ... }:
    let
      inherit (config.networking.wireguard.interfaces) peridot;
      inherit (config.services)
        deemix-server
        forgejo
        gonic
        nix-mc
        steam-dedicated
        ;

      git.port = forgejo.settings.server.HTTP_PORT;
      minecraft.ports = lib.attrValues
        (lib.mapAttrs
          (_: instance: lib.mkIf instance.enable instance.serverConfig.server-port)
          nix-mc.instances);
      steam.ports = lib.flatten (lib.attrValues
        (lib.mapAttrs
          # Port 27015 is used for steam server discovery
          (_: server: lib.optionals server.enable [ server.port (server.port + 1) 27015 ])
          steam-dedicated));
    in {
      networking.firewall.interfaces = {
        eno1.allowedUDPPorts = [ peridot.listenPort ];
        peridot = {
          allowedUDPPorts = steam.ports ++ minecraft.ports;
          allowedTCPPorts = lib.flatten [
            20
            80
            443
            27020 # Ark RCON
            deemix-server.port
            git.port
            gonic.port
            minecraft.ports
            steam.ports
            peridot.listenPort
          ];
        };
      };
    })
  ];
}
