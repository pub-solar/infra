{
  flake,
  config,
  pkgs,
  ...
}:
let
  publicDomain = "matrix.${config.pub-solar-os.networking.domain}";
  serverDomain = "${config.pub-solar-os.networking.domain}";
in
{
  age.secrets."matrix-synapse-signing-key" = {
    file = "${flake.self}/secrets/matrix-synapse-signing-key.age";
    mode = "400";
    owner = "matrix-synapse";
  };

  age.secrets."matrix-synapse-secret-config.yaml" = {
    file = "${flake.self}/secrets/matrix-synapse-secret-config.yaml.age";
    mode = "400";
    owner = "matrix-synapse";
  };

  age.secrets."matrix-synapse-sliding-sync-secret" = {
    file = "${flake.self}/secrets/matrix-synapse-sliding-sync-secret.age";
    mode = "400";
    owner = "matrix-synapse";
  };

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

      signing_key_path = "/run/agenix/matrix-synapse-signing-key";

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

      app_service_config_files = [
        "/var/lib/matrix-synapse/telegram-registration.yaml"
        "/var/lib/matrix-appservice-irc/registration.yml"
        # "/matrix-appservice-slack-registration.yaml"
        # "/hookshot-registration.yml"
        # "/matrix-mautrix-signal-registration.yaml"
        # "/matrix-mautrix-telegram-registration.yaml"
      ];
    };

    withJemalloc = true;

    extraConfigFiles = [
      "/run/agenix/matrix-synapse-secret-config.yaml"

      # The registration file is automatically generated after starting the
      # appservice for the first time.
      # cp /var/lib/mautrix-telegram/telegram-registration.yaml \
      #   /var/lib/matrix-synapse/
      # chown matrix-synapse:matrix-synapse \
      #   /var/lib/matrix-synapse/telegram-registration.yaml
      "/var/lib/matrix-synapse/telegram-registration.yaml"
    ];

    extras = [
      "oidc"
      "redis"
    ];

    plugins = [ config.services.matrix-synapse.package.plugins.matrix-synapse-shared-secret-auth ];
  };

  services.matrix-sliding-sync = {
    enable = true;
    settings = {
      SYNCV3_SERVER = "https://${publicDomain}";
      SYNCV3_BINDADDR = "127.0.0.1:8011";
      # The bind addr for Prometheus metrics, which will be accessible at
      # /metrics at this address
      SYNCV3_PROM = "127.0.0.1:9100";
    };
    environmentFile = config.age.secrets."matrix-synapse-sliding-sync-secret".path;
  };

  services.restic.backups.matrix-synapse-storagebox = {
    paths = [
      "/var/lib/matrix-synapse"
      "/var/lib/matrix-appservice-irc"
      "/var/lib/mautrix-telegram"
      "/tmp/matrix-synapse-backup.sql"
    ];
    timerConfig = {
      OnCalendar = "*-*-* 05:00:00 Etc/UTC";
    };
    initialize = true;
    passwordFile = config.age.secrets."restic-repo-storagebox-nachtigall".path;
    repository = "sftp:u377325@u377325.your-storagebox.de:/backups";
    backupPrepareCommand = ''
      ${pkgs.sudo}/bin/sudo -u postgres ${pkgs.postgresql}/bin/pg_dump -d matrix > /tmp/matrix-synapse-backup.sql
    '';
    backupCleanupCommand = ''
      rm /tmp/matrix-synapse-backup.sql
    '';
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 3"
    ];
  };
}
