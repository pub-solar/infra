{
  config,
  lib,
  flake,
  ...
}:
{
  age.secrets."nextcloud-serverinfo-token" = {
    file = "${flake.self}/secrets/nextcloud-serverinfo-token.age";
    mode = "400";
    owner = "nextcloud-exporter";
  };

  services.prometheus = {
    exporters = {
      # https://github.com/xperimental/nextcloud-exporter
      nextcloud = {
        enable = true;
        openFirewall = true;
        firewallFilter = "--in-interface wg-ssh --protocol tcp --match tcp --dport ${toString config.services.prometheus.exporters.nextcloud.port}";
        url = "https://cloud.pub.solar";
        tokenFile = config.age.secrets."nextcloud-serverinfo-token".path;
        port = 9205;
      };
      # https://github.com/nginx/nginx-prometheus-exporter
      nginx = {
        enable = true;
        openFirewall = true;
        firewallFilter = "--in-interface wg-ssh --protocol tcp --match tcp --dport ${toString config.services.prometheus.exporters.nginx.port}";
        port = 9113;
      };
      # https://github.com/hipages/php-fpm_exporter
      #php-fpm = {
      #  enable = true;
      #  extraFlags = [
      #    "--phpfpm.scrape-uri unix://${config.services.phpfpm.pools.nextcloud.socket};/status"
      #  ];
      #  group = "nginx";
      #  openFirewall = true;
      #  firewallFilter = "--in-interface wg-ssh --protocol tcp --match tcp --dport ${toString config.services.prometheus.exporters.php-fpm.port}";
      #  port = 9253;
      #};
      # https://github.com/prometheus-community/postgres_exporter
      postgres = {
        enable = true;
        dataSourceName = "user=postgres-exporter database=postgres host=/run/postgresql sslmode=disable";
        openFirewall = true;
        firewallFilter = "--in-interface wg-ssh --protocol tcp --match tcp --dport ${toString config.services.prometheus.exporters.postgres.port}";
        port = 9187;
      };
    };
  };
}
