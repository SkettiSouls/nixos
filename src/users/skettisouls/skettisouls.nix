{ inputs, config, ... }:
{
  flake.users.skettisouls = config.flake.lib.perSystem
    ({ system, ... }:
    let
      # TODO: Figure out how to include required config for a wrapper
      #       e.g. Niri wrapper forces `programs.niri.enable`
      inherit (config.flake.users.skettisouls.${system}) wrappers;
    in {
      # shell = wrappers.nushell;
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
