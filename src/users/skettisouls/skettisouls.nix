{ inputs, config, ... }:
{
  flake.users.skettisouls = config.flake.lib.perSystem
    ({ system, mkWrappers, ... }:
    let
      # TODO: Figure out how to include required config for a wrapper
      #       E.G. Niri wrapper forces `programs.niri.enable`
      wrappers = mkWrappers ./wrappers // {
        inherit (inputs.neovim.packages.${system}) neovim neovim-impure;
      };
    in {
      inherit wrappers;
      # shell = wrappers.nushell;
      groups = [ "networkmanager" "wheel" ];
      packages = with wrappers; [
        eza
        git
        lazygit
        neovim
      ];
    });
}
