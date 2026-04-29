{ wlib, pkgs, ... }:
let
  gitWrapped = (wlib.evalModule ./git.nix).config.wrap { inherit pkgs; };
in
{
  imports = [ wlib.modules.default ];

  config = {
    package = pkgs.lazygit;
    extraPackages = [ gitWrapped ];

    flags = {
      "--use-config-file" = ./lazygit.yml;
    };
  };
}
