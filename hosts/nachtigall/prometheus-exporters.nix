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
      php-fpm = {
        enable = true;
        openFirewall = true;
        firewallRules = [
          ''iifname "wg-ssh" tcp dport ${config.services.prometheus.exporters.php-fpm.port} accept''
        ];
        port = 9253;
      };
      # https://github.com/prometheus-community/postgres_exporter
      postgres = {
        enable = true;
        dataSourceName = "postgres_exporter@:5432/postgres?host=/run/postgresql";
        openFirewall = true;
        firewallFilter = "--in-interface wg-ssh --protocol tcp --match tcp --dport ${toString config.services.prometheus.exporters.postgres.port}";
        port = 9187;
      };
      # https://github.com/pdf/zfs_exporter
      zfs = {
        enable = true;
        openFirewall = true;
        firewallRules = [
          ''iifname "wg-ssh" tcp dport ${config.services.prometheus.exporters.zfs.port} accept''
        ];
        port = 9134;
      };
    };
  };
}
