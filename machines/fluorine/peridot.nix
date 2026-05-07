{
  flake.machines.fluorine.modules = [(
    { pkgs, ... }:
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
    }
  )];
}
