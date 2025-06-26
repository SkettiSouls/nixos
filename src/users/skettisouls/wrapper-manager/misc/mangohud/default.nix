# NOTE: `MANGOHUD=1 ignores this config`
# TODO: Find a workaround for the above note
{ pkgs, ... }:

{
  wrappers.mangohud = {
    basePackage = pkgs.mangohud;

    programs.mangohud = {
      env.MANGOHUD_CONFIGFILE.value = "${./MangoHud.conf}";
    };
  };
}
