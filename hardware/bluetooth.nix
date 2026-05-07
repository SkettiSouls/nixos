# TODO: Expand
{
  flake.modules.hardware.bluetooth =
    { ... }:
    {
      config = {
        hardware.bluetooth = {
          enable = true;
          powerOnBoot = true;
          # input = { };
          # settings = { };
          # disabledPlugins = [ ];
        };
      };
    };
}
