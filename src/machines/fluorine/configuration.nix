{ ... }:
let
  # TODO: Handle keys better
  keys = {
    argon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILU3q+/0jJLkAtvCk3hJ+QAXCvza7SZ9a0V6FZq6IJne";
  };
in
{
  nix.settings.trusted-users = [ "skettisouls" ];

  users.users.skettisouls.openssh.authorizedKeys.keys = with keys; [
    argon
  ];

  users.users.root.openssh.authorizedKeys.keys = with keys; [
    argon
  ];

  networking = {
    firewall.allowedTCPPorts = [ 80 ];
    interfaces.enp37s0.ipv4.addresses = [{
      address = "192.168.1.17";
      prefixLength = 24;
    }];
  };

  time.timeZone = "America/Chicago";
  system.stateVersion = "24.05";
}
