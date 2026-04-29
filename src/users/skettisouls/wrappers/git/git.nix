{ wlib, pkgs, ... }:

{
  imports = [ wlib.wrapperModules.git ];

  config = {
    settings = {
      commit.gpgSign = true;
      gpg.format = "ssh";
      "gpg \"openpgp\"".program = "${pkgs.gnupg}/bin/gpg";
      pull.rebase = false;
      tag.gpgSign = true;
      user = {
        name = "SkettiSouls";
        email = "skettisouls@gmail.com";
        # TODO: replace with age/sops secret
        signingKey = "/home/skettisouls/.keys/ssh/git.key"; 
      };
    };
  };
}
