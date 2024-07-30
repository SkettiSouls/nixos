{
  services = {
    invidious = {
      enable = true;
      port = 3030;
    };

    nginx = {
      enable = true;
      virtualHosts."inv.fluorine.lan" = {
        enableACME = false;
        forceSSL = false;
        locations."/".proxyPass = "http://127.0.0.1:3030/";
      };
    };
  };
}
