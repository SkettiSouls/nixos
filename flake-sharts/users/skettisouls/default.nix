{
  config.flake = {
    users.skettisouls = {
      home-manager.enable = true;
      wrapper-manager = {
        enable = true;
        installedWrappers = [
          "eza"
          "feishin"
          "nushell"
        ];
      };
    };

    userModules.skettisouls = {
      home-manager = import ./home-manager;
      wrapper-manager = import ./wrapper-manager;
    };
  };
}
