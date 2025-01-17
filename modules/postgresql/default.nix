{ ... }:

{
  services.postgresql = {
    enable = true;
    # Required for MediaWiki, connects via docker network
    enableTCPIP = true;
    # https://pgtune.leopard.in.ua/ DB Version: 14 OS Type: linux DB Type: web
    # Total Memory (RAM): 8 GB Data Storage: ssd
    settings = {
      max_connections = 200;
      shared_buffers = "2GB";
      effective_cache_size = "6GB";
      maintenance_work_mem = "512MB";
      checkpoint_completion_target = 0.9;
      wal_buffers = "16MB";
      default_statistics_target = 100;
      random_page_cost = 1.1;
      effective_io_concurrency = 200;
      work_mem = "5242kB";
      huge_pages = "off";
      min_wal_size = "1GB";
      max_wal_size = "4GB";
      # ZFS is always consistent (Copy-On-Write)
      full_page_writes = false;
    };
  };
}
