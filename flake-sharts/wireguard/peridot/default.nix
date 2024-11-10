{
  wireguard.networks.peridot = {
    # TODO: Switch to using sops/agenix
    peers.by-name = {
      argon.privateKeyFile = "/var/lib/wireguard/key";
      fluorine.privateKeyFile = "/var/lib/wireguard/key";
    };
  };
}
