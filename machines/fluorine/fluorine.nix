{ config, ... }:
let
  inherit (config.flake.lib) mkUsers;
  inherit (config.flake.modules) bundles networks;

  system = "x86_64-linux";

  # TODO: Handle keys better
  keys = {
    argon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILU3q+/0jJLkAtvCk3hJ+QAXCvza7SZ9a0V6FZq6IJne";
  };
in
{
  flake.machines.fluorine = {
    inherit system;
    networks = with networks; [ peridot ];

    users = mkUsers system {
      inherit (config.flake.users) skettisouls;
    };

    modules = [
      bundles.workstation

      {
        boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
        nix.settings.trusted-users = [ "skettisouls" ];

        users.users = {
          root.openssh.authorizedKeys.keys = with keys; [ argon ];
          skettisouls.openssh.authorizedKeys.keys = with keys; [ argon ];
        };

        networking = {
          firewall.allowedTCPPorts = [ 80 ];
          interfaces.enp37s0.ipv4.addresses = [{
            address = "192.168.1.17";
            prefixLength = 24;
          }];
        };

        system.stateVersion = "24.05";
      }
    ];
  };
}
