{
  programs.ssh.knownHosts = {
    fluorine = {
      extraHostNames = [ "fluorine.lan" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ9+aV5l1TNUc0vi0eaXNg7VkyZSoQPNJStdiMXdjx6E";
    };
  };
}
