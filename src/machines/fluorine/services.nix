{ self, ... }:

{
  imports = with self.serviceModules; [
    ark
    caddy
    deemix
    discord-bots
    forgejo
    gonic
    minecraft
    postgres
    valheim
  ];
}
