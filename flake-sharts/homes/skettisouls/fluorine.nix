{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [];

  shit = {
    fetch.neofetch = {
      enable = true;
      showHost = true;
    };
  };
}
