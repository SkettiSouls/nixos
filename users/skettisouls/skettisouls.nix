{ inputs, config, ... }:
{
  flake.users.skettisouls = config.flake.lib.perSystem
    ({ system, ... }:
    let
      inherit (config.flake.users.skettisouls.${system}) wrappers;
    in {
      shell = "${wrappers.bash}/bin/bash";
      groups = [ "networkmanager" "wheel" ];

      packages = with wrappers; [
        eza
        git
        lazygit
        neovim
      ];

      wrappers = {
        inherit (inputs.neovim.packages.${system}) neovim neovim-impure;
      };
    });
}
