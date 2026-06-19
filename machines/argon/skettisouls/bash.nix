{ config, lib, ... }:
let
  inherit (config.flake.machines.argon) system;
  inherit (config.flake.users.skettisouls.${system}.wrappers) bash neovim-impure;
in
{
  flake.machines.argon.users.skettisouls.wrappers.bash = lib.mkForce (bash.wrap {
    bashrc.content = bash.bashrc + ''
      alias v=${neovim-impure}/bin/nvim
    '';
  });
}
