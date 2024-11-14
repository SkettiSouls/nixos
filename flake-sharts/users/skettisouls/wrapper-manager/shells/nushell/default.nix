{ pkgs', ... }:

{
  wrappers.nushell = {
    basePackage = pkgs'.unstable.nushell;
    pathAdd = [ pkgs'.unstable.carapace ];

    flags = [ "--env-config" ./env.nu "--config" ./config.nu ];
  };
}
