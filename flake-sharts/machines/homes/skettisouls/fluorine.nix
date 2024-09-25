{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [];

  shit = {
    neofetch = {
      enable = true;
      showHost = true;
    };
  };
}
