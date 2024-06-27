{ config, lib, pkgs, ... }:

{
  imports = [
    ../../../modules/home
  ];

  home.packages = with pkgs; [];

  shit = {
    fetch.neofetch = {
      enable = true;
      showHost = true;
    };
  };
}
