{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [];

  regolith = {
    neofetch = {
      enable = true;
      showHost = true;
    };
  };
}
