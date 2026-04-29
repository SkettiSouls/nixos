{
  flake.modules.nixos.nix-index =
    { ... }:
    {
      programs = {
        # Mutually exclusive with nix-index, and depends on channels
        command-not-found.enable = false;

        nix-index = {
          enable = true;
          enableBashIntegration = true;
        };
      };
    };
}
