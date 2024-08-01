{
  services = {
    deemix-server = {
      enable = true;
      listenAddress = "0.0.0.0";
    };

    # FIXME: "Couldn't connect to local server."
    # Seemingly only happens with nginx (tested with wireguard and local IP)
    nginx = {
      enable = true;
      virtualHosts."deemix.fluorine.lan" = {
        enableACME = false;
        forceSSL = false;
        locations."/".proxyPass = "http://127.0.0.1:6595";
      };
    };
  };
}
