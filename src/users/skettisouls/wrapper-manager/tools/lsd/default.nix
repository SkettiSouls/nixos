{ pkgs, ... }:

{
  wrappers.lsd = {
    basePackage = pkgs.lsd;
    prependFlags = [ "--config-file" ./config.yaml ];
  };
}
