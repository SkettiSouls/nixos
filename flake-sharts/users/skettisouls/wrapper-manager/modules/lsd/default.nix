{ pkgs, ... }:

{
  wrappers.lsd = {
    basePackage = pkgs.lsd;

    flags = [ "--config-file" ./config.yaml ];
  };
}
