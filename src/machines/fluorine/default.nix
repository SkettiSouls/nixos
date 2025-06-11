{ inputs, ... }:
{ config, ... }:
let
  inherit (config.flake) networks roles wrappers;
  inherit (inputs.neovim.packages.${system}) neovim;

  system = "x86_64-linux";
  wpkgs = wrappers.${system};
  pkgs = inputs.nixpkgs.legacyPackages.${system};
  iptables = "${pkgs.iptables}/bin/iptables";
in
{
  flake.machines.fluorine = {
    inherit system;
    roles = with roles; [ workstation ];
    networks = with networks; [
      peridot
      {
        networking.wireguard.interfaces.peridot = {
          ips = [ "192.168.10.1/24" ];
          postSetup = "${iptables} -A FORWARD -i %i -j ACCEPT; ${iptables} -A FORWARD -o %i -j ACCEPT; ${iptables} -t nat -A POSTROUTING -o eno1 -j MASQUERADE";
          postShutdown = "${iptables} -D FORWARD -i %i -j ACCEPT; ${iptables} -D FORWARD -o %i -j ACCEPT; ${iptables} -t nat -D POSTROUTING -o eno1 -j MASQUERADE";
        };
      }
    ];

    users.skettisouls = {
      packages = with wpkgs.skettisouls; [
        eza
        neovim
      ] ++ (with pkgs; [
        lazygit
      ]);
    };

    modules = [
      ./configuration.nix
      ./hardware-configuration.nix
      ./services.nix
    ];
  };
}
