{ config, ... }:
{
  flake.users.skettisouls = config.flake.lib.perSystem
    ({ wlib, pkgs, ... }:
    {
      wrappers.git = wlib.wrapPackage {
        imports = [ wlib.wrapperModules.git ];

        config = {
          inherit pkgs;
          settings = {
            commit.gpgSign = true;
            gpg.format = "ssh";
            "gpg \"openpgp\"".program = "${pkgs.gnupg}/bin/gpg";
            pull.rebase = false;
            tag.gpgSign = true;
            user = {
              name = "SkettiSouls";
              email = "skettisouls@gmail.com";
              # TODO 5: replace with age/sops secret
              signingKey = "/home/skettisouls/.keys/ssh/git.key"; 
            };
          };
        };
      };
    });
}
