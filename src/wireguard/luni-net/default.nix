{ inputs, config, ... }:
{
  wireguard.networks.lunk.privateKeyFile = "/var/lib/wireguard/privatekey";

  flake.nixosModule = {
    imports = [ inputs.lynx.nixosModules.flake-guard-host ];
    wireguard.networks = config.wireguard.networks;
  };
}
