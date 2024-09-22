{ self, ... }:

{
  imports = [
    (self.wrapperModules.default { user = "skettisouls"; })
  ];

  config = {
    wrapper-manager = {
      enable = true;
      packages = [
        ./modules/qutebrowser
      ];
    };
  };
}
