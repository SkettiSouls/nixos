{
  flake.modules.nixos.pipewire =
    { ... }:
    {
      # Enable realtime priority
      security.rtkit.enable = true;

      services.pipewire = {
        enable = true;
        audio.enable = true;
        wireplumber.enable = true;

        alsa.enable = true;
        alsa.support32Bit = true;
        jack.enable = true;
        pulse.enable = true;
      };
    };
}
