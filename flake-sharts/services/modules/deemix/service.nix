{
  shit.deemix-server.enable = true;

  services.nginx = {
    enable = true;
    virtualHosts."deemix.fluorine.lan" = {
      enableACME = false;
      forceSSL = false;
      locations."/".proxyPass = "http://127.0.0.1:6595";
    };
  };
}
