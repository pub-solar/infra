{
  flake,
  config,
  lib,
  pkgs,
  ...
}:
let
  publicDomain = "matrix.${config.pub-solar-os.networking.domain}";
  serverDomain = "${config.pub-solar-os.networking.domain}";
in
{
  options.pub-solar-os = {
    matrix = {
      enable = lib.mkEnableOption "Enable matrix-synapse and matrix-authentication-service to run on the node";

      synapse = {
        app-service-config-files = lib.mkOption {
          description = "List of app service config files";
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };

        extra-config-files = lib.mkOption {
          description = "List of extra synapse config files";
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };

        signing_key_path = lib.mkOption {
          description = "Path to file containing the signing key";
          type = lib.types.str;
          default = "${config.services.matrix-synapse.dataDir}/homeserver.signing.key";
        };
      };

      matrix-authentication-service = {
        extra-config-files = lib.mkOption {
          description = "List of extra mas config files";
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };
      };
    };
  };

  config = lib.mkIf config.pub-solar-os.matrix.enable {
    services.matrix-synapse = {
      enable = true;
      settings = {
        server_name = serverDomain;
        public_baseurl = "https://${publicDomain}/";
        database = {
          name = "psycopg2";
          args = {
            host = "/run/postgresql";
            cp_max = 10;
            cp_min = 5;
            database = "matrix";
          };
          allow_unsafe_locale = false;
          txn_limit = 0;
        };
        listeners = [
          {
            bind_addresses = [ "127.0.0.1" ];
            port = 8008;
            resources = [
              {
                compress = true;
                names = [ "client" ];
              }
              {
                compress = false;
                names = [ "federation" ];
              }
            ];
            tls = false;
            type = "http";
            x_forwarded = true;
          }
          {
            bind_addresses = [ "127.0.0.1" ];
            port = 8012;
            resources = [ { names = [ "metrics" ]; } ];
            tls = false;
            type = "metrics";
          }
        ];

        account_threepid_delegates.msisdn = "";
        alias_creation_rules = [
          {
            action = "allow";
            alias = "*";
            room_id = "*";
            user_id = "*";
          }
        ];
        allow_guest_access = false;
        allow_public_rooms_over_federation = true;
        allow_public_rooms_without_auth = false;
        auto_join_rooms = [
          "#community:${serverDomain}"
          "#general:${serverDomain}"
        ];

        autocreate_auto_join_rooms = true;
        caches.global_factor = 0.5;

        default_room_version = "10";
        disable_msisdn_registration = true;
        enable_media_repo = true;
        enable_metrics = true;
        mau_stats_only = true;
        enable_registration = false;
        enable_registration_captcha = false;
        enable_registration_without_verification = false;
        enable_room_list_search = true;
        encryption_enabled_by_default_for_room_type = "off";
        event_cache_size = "100K";

        # https://github.com/element-hq/synapse/issues/11203
        # No YAML deep-merge, so this needs to be in secret extraConfigFiles
        # together with msc3861
        #experimental_features = {
        #  # Room summary API
        #  msc3266_enabled = true;
        #  # Rendezvous server for QR Code generation
        #  msc4108_enabled = true;
        #};

        federation_rr_transactions_per_room_per_second = 50;
        federation_client_minimum_tls_version = "1.2";
        forget_rooms_on_leave = true;
        include_profile_data_on_invite = true;
        instance_map = { };
        limit_profile_requests_to_users_who_share_rooms = false;

        max_spider_size = "10M";
        max_upload_size = "50M";
        media_storage_providers = [ ];

        password_config = {
          enabled = false;
          localdb_enabled = false;
          pepper = "";
        };

        presence.enabled = true;
        push.include_content = false;

        rc_admin_redaction = {
          burst_count = 50;
          per_second = 1;
        };
        rc_federation = {
          concurrent = 3;
          reject_limit = 50;
          sleep_delay = 500;
          sleep_limit = 10;
          window_size = 1000;
        };
        rc_invites = {
          per_issuer = {
            burst_count = 10;
            per_second = 0.3;
          };
          per_room = {
            burst_count = 10;
            per_second = 0.3;
          };
          per_user = {
            burst_count = 5;
            per_second = 3.0e-3;
          };
        };
        rc_joins = {
          local = {
            burst_count = 10;
            per_second = 0.1;
          };
          remote = {
            burst_count = 10;
            per_second = 1.0e-2;
          };
        };
        rc_login = {
          account = {
            burst_count = 3;
            per_second = 0.17;
          };
          address = {
            burst_count = 3;
            per_second = 0.17;
          };
          failed_attempts = {
            burst_count = 3;
            per_second = 0.17;
          };
        };
        rc_message = {
          burst_count = 10;
          per_second = 0.2;
        };
        rc_registration = {
          burst_count = 3;
          per_second = 0.17;
        };
        redaction_retention_period = "7d";
        forgotten_room_retention_period = "7d";
        redis.enabled = false;
        registration_requires_token = false;
        registrations_require_3pid = [ "email" ];
        report_stats = false;
        require_auth_for_profile_requests = false;
        room_list_publication_rules = [
          {
            action = "allow";
            alias = "*";
            room_id = "*";
            user_id = "*";
          }
        ];

        signing_key_path = config.pub-solar-os.matrix.synapse.signing_key_path;

        stream_writers = { };
        trusted_key_servers = [ { server_name = "matrix.org"; } ];
        suppress_key_server_warning = true;

        turn_allow_guests = false;
        turn_uris = [
          "turn:${config.services.coturn.realm}:3478?transport=udp"
          "turn:${config.services.coturn.realm}:3478?transport=tcp"
        ];
        turn_user_lifetime = "1h";

        url_preview_accept_language = [
          "en-US"
          "en"
        ];
        url_preview_enabled = true;
        url_preview_ip_range_blacklist = [
          "127.0.0.0/8"
          "10.0.0.0/8"
          "172.16.0.0/12"
          "192.168.0.0/16"
          "100.64.0.0/10"
          "192.0.0.0/24"
          "169.254.0.0/16"
          "192.88.99.0/24"
          "198.18.0.0/15"
          "192.0.2.0/24"
          "198.51.100.0/24"
          "203.0.113.0/24"
          "224.0.0.0/4"
          "::1/128"
          "fe80::/10"
          "fc00::/7"
          "2001:db8::/32"
          "ff00::/8"
          "fec0::/10"
        ];

        user_directory = {
          prefer_local_users = false;
          search_all_users = false;
        };
        user_ips_max_age = "28d";

        app_service_config_files = config.pub-solar-os.matrix.synapse.app-service-config-files;
      };

      withJemalloc = true;

      extraConfigFiles = config.pub-solar-os.matrix.synapse.extra-config-files;

      extras = [
        "oidc"
        "redis"
      ];

      plugins = [ config.services.matrix-synapse.package.plugins.matrix-synapse-shared-secret-auth ];
    };

    services.matrix-authentication-service = {
      enable = true;
      createDatabase = true;
      extraConfigFiles = config.pub-solar-os.matrix.matrix-authentication-service.extra-config-files;

      # https://element-hq.github.io/matrix-authentication-service/reference/configuration.html
      settings = {
        account.email_change_allowed = false;
        http.public_base = "https://mas.${config.pub-solar-os.networking.domain}";
        http.issuer = "https://mas.${config.pub-solar-os.networking.domain}";
        http.listeners = [
          {
            name = "web";
            resources = [
              { name = "discovery"; }
              { name = "human"; }
              { name = "oauth"; }
              { name = "compat"; }
              { name = "graphql"; }
              {
                name = "assets";
                path = "${config.services.matrix-authentication-service.package}/share/matrix-authentication-service/assets";
              }
            ];
            binds = [
              {
                host = "0.0.0.0";
                port = 8090;
              }
            ];
            proxy_protocol = false;
          }
          {
            name = "internal";
            resources = [
              { name = "health"; }
            ];
            binds = [
              {
                host = "0.0.0.0";
                port = 8081;
              }
            ];
            proxy_protocol = false;
          }
        ];
        passwords.enabled = false;
      };
    };

    pub-solar-os.backups.restic.matrix-synapse = {
      paths = [
        "/var/lib/matrix-synapse"
        "/var/lib/matrix-appservice-irc"
        "/var/lib/mautrix-telegram"
        "/tmp/matrix-synapse-backup.sql"
        "/tmp/matrix-authentication-service-backup.sql"
      ];
      timerConfig = {
        OnCalendar = "*-*-* 05:00:00 Etc/UTC";
      };
      initialize = true;
      backupPrepareCommand = ''
        ${pkgs.sudo}/bin/sudo -u postgres ${pkgs.postgresql}/bin/pg_dump -d matrix > /tmp/matrix-synapse-backup.sql
        ${pkgs.sudo}/bin/sudo -u postgres ${pkgs.postgresql}/bin/pg_dump -d matrix-authentication-service > /tmp/matrix-authentication-service-backup.sql
      '';
      backupCleanupCommand = ''
        rm /tmp/matrix-synapse-backup.sql
        rm /tmp/matrix-authentication-service-backup.sql
      '';
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 3"
      ];
    };
  };
}
