{ self, ... }:
let
  keys = {
    argon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILU3q+/0jJLkAtvCk3hJ+QAXCvza7SZ9a0V6FZq6IJne";
  };
in
{
  imports = with self.serviceModules; [
    airsonic
    deemix
    postgres
  ];

  roles = with self.roles; [
    server
    workstation
  ];

  networking.hostName = "fluorine";

  users.users.skettisouls.openssh.authorizedKeys.keys = with keys; [
    argon
  ];

  users.users.root.openssh.authorizedKeys.keys = with keys; [
    argon
  ];

  # Set your time zone.
  time.timeZone = "America/Chicago";

  nix.settings.trusted-users = [
    "skettisouls"
  ];

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 80 ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  system.stateVersion = "24.05";
}
