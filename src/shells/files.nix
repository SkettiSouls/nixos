# Shell for handling files (mostly decompression)
{ ... }:

{
  perSystem = { pkgs, ... }: {
    devShells.files = pkgs.mkShell {
      packages = with pkgs; [
        zip
        unzip
        p7zip
        unrar
      ];
    };
  };
}
