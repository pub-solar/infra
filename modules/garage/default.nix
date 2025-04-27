{
  config,
  lib,
  pkgs,
  flake,
  ...
}:
{
  age.secrets."garage-rpc-secret" = {
    file = "${flake.self}/secrets/garage-rpc-secret.age";
    mode = "400";
  };

  age.secrets."garage-admin-token" = {
    file = "${flake.self}/secrets/garage-admin-token.age";
    mode = "400";
  };

  age.secrets."acme-namecheap-env" = {
    file = "${flake.self}/secrets/acme-namecheap-env.age";
    mode = "400";
  };

  networking.firewall.allowedTCPPorts = [
    3900
    3901
    3902
  ];

  networking.firewall.interfaces.wg-ssh.allowedTCPPorts = [ 3903 ];

  security.acme = {
    defaults = {
      # LEGO_DISABLE_CNAME_SUPPORT=true set here to fix issues with CNAME
      # detection, as we use wildcard DNS for garage
      environmentFile = config.age.secrets.acme-namecheap-env.path;
    };
    certs = {
      # Wildcard certificate gets created automatically
      "buckets.${config.pub-solar-os.networking.domain}" = {
        # disable http challenge
        webroot = null;
        # enable dns challenge
        dnsProvider = "namecheap";
      };
      # Wildcard certificate gets created automatically
      "web.${config.pub-solar-os.networking.domain}" = {
        # disable http challenge
        webroot = null;
        # enable dns challenge
        dnsProvider = "namecheap";
      };
    };
  };

  services.nginx = {
    upstreams.s3_backend.servers = {
      "[::1]:3900" = { };
    };
    upstreams.web_backend.servers = {
      "[::1]:3902" = { };
    };
    virtualHosts."buckets.${config.pub-solar-os.networking.domain}" = {
      serverAliases = [ "*.buckets.${config.pub-solar-os.networking.domain}" ];

      enableACME = true;
      forceSSL = true;
      listen = [
        {
          addr = "0.0.0.0";
          port = 80;
          ssl = false;
        }
        {
          addr = "[::]";
          port = 80;
          ssl = false;
        }
        {
          addr = "127.0.0.1";
          port = 8443;
          proxyProtocol = true;
          ssl = true;
        }
      ];

      locations."/" = {
        proxyPass = "http://s3_backend";
        extraConfig = ''
          client_max_body_size 64m;
          proxy_max_temp_file_size 0;
        '';
      };
    };
    virtualHosts."web.${config.pub-solar-os.networking.domain}" = {
      serverAliases = [ "*.web.${config.pub-solar-os.networking.domain}" ];

      enableACME = true;
      forceSSL = true;

      listen = [
        {
          addr = "0.0.0.0";
          port = 80;
          ssl = false;
        }
        {
          addr = "[::]";
          port = 80;
          ssl = false;
        }
        {
          addr = "127.0.0.1";
          port = 8443;
          proxyProtocol = true;
          ssl = true;
        }
      ];

      locations."/" = {
        proxyPass = "http://web_backend";
      };
    };
  };

  services.garage = {
    enable = true;
    package = pkgs.garage_1_1_0;
    settings = {
      data_dir = "/var/lib/garage/data";
      metadata_dir = "/var/lib/garage/meta";
      db_engine = "lmdb";
      replication_factor = 3;
      compression_level = 2;
      rpc_bind_addr = "[::]:3901";
      s3_api = {
        s3_region = "eu-central";
        api_bind_addr = "[::]:3900";
        root_domain = ".buckets.${config.pub-solar-os.networking.domain}";
      };
      s3_web = {
        bind_addr = "[::]:3902";
        root_domain = ".web.${config.pub-solar-os.networking.domain}";
        index = "index.html";
      };
      admin = {
        api_bind_addr = "[::]:3903";
      };
    };
  };

  users.users.garage = {
    isSystemUser = true;
    home = "/var/lib/garage";
    group = "garage";
  };

  users.groups.garage = { };

  # Adapted from https://git.clan.lol/clan/clan-core/src/commit/23a9e35c665ff531fe1193dcc47056432fbbeacf/clanModules/garage/default.nix
  # Disabled DynamicUser https://github.com/NixOS/nixpkgs/blob/nixos-24.05/nixos/modules/services/web-servers/garage.nix
  # for mounts + permissions to work
  systemd.services.garage = {
    serviceConfig = {
      user = "garage";
      group = "garage";
      DynamicUser = false;
      LoadCredential = [
        "rpc_secret_path:${config.age.secrets.garage-rpc-secret.path}"
        "admin_token_path:${config.age.secrets.garage-admin-token.path}"
      ];
      Environment = [
        "GARAGE_ALLOW_WORLD_READABLE_SECRETS=true"
        "GARAGE_RPC_SECRET_FILE=%d/rpc_secret_path"
        "GARAGE_ADMIN_TOKEN_FILE=%d/admin_token_path"
      ];
    };
  };
}
