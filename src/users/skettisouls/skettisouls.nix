{ inputs, config, ... }:
{
  flake.users.skettisouls = config.flake.lib.perSystem
    ({ system, wrap, ... }:
    let
      # TODO: Automatically import and wrap packages;
      # TODO: Figure out how to include required config for a wrapper
      #       E.G. Niri wrapper forces `programs.niri.enable`
      wrappers = {
        inherit (inputs.neovim.packages.${system}) neovim neovim-impure;
        eza = wrap ./wrappers/eza.nix;
        feishin = wrap ./wrappers/feishin.nix;
        git = wrap ./wrappers/git/git.nix;
        lazygit = wrap ./wrappers/git/lazygit.nix;
        mangohud = wrap ./wrappers/mangohud.nix;
        qutebrowser = wrap ./wrappers/qutebrowser/qutebrowser.nix;
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
