{ ... }:

{
  services.postgresql = {
    enable = true;
    enableTCPIP = true;
  };

  systemd.services.postgresql = {
    after = [ "var-lib-postgresql.mount" ];
    requisite = [ "var-lib-postgresql.mount" ];
  };
}
