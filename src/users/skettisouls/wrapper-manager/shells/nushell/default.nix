{ pkgs', ... }:

{
  wrappers.nushell = {
    basePackage = pkgs'.unstable.nushell;
    flags = [ "--env-config" ./env.nu "--config" ./config.nu ];
  };
}
