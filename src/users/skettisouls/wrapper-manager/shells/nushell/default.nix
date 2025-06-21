{ pkgs, ... }:

{
  wrappers.nushell = {
    basePackage = pkgs.unstable.nushell;
    prependFlags = [ "--env-config" ./env.nu "--config" ./config.nu ];
  };
}
