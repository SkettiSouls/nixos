# TODO 1: Fix luni-net
{
  wireguard.networks.asluni = {
    peers.by-name = {
      argon.privateKeyFile = "/var/lib/wireguard/privatekey";
      fluorine.privateKeyFile = "/var/lib/wireguard/privatekey";
    };
  };
}
