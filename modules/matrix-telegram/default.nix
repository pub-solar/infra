{
  flake,
  lib,
  config,
  pkgs,
  ...
}:
{
  age.secrets."matrix-mautrix-telegram-env-file" = {
    file = "${flake.self}/secrets/matrix-mautrix-telegram-env-file.age";
    mode = "400";
    owner = "matrix-synapse";
  };

  services.mautrix-telegram = {
    enable = true;
    environmentFile = "/run/agenix/matrix-mautrix-telegram-env-file";
    settings = {
      homeserver = {
        # TODO: Use the port from synapse config
        address = "http://127.0.0.1:8008";
        domain = "${config.pub-solar-os.networking.domain}";
        verify_ssl = true;
      };
      appservice = {
        address = "http://127.0.0.1:8009";
        bot_avatar = "mxc://maunium.net/tJCRmUyJDsgRNgqhOgoiHWbX";
        bot_displayname = "Telegram bridge bot";
        bot_username = "telegrambot";
        # TODO: See if we can use postgresql
        database = "sqlite:////var/lib/mautrix-telegram/sqlite.db";
        hostname = "0.0.0.0";
        id = "telegram";
        max_body_size = 1;
        port = 8009;
        provisioning = {
          enabled = false;
          prefix = "/_matrix/provision/v1";
          shared_secret = "generate";
        };
        public = {
          enabled = true;
          external = "https://matrix.${config.pub-solar-os.networking.domain}/c3c3f34b-29fb-5feb-86e5-98c75ec8214b";
          prefix = "/c3c3f34b-29fb-5feb-86e5-98c75ec8214b";
        };
      };
      bridge = {
        alias_template = "telegram_{groupname}";
        allow_matrix_login = true;
        # Animated stickers conversion requires additional packages in the
        # service's path.
        # If this isn't a fresh installation, clearing the bridge's uploaded
        # file cache might be necessary (make a database backup first!):
        # delete from telegram_file where \
        #   mime_type in ('application/gzip', 'application/octet-stream')
        animated_sticker = {
          args = {
            background = "'020202'"; # only for gif, transparency not supported
            fps = 30; # only for webm
            height = 256;
            width = 256;
          };
          target = "gif";
        };
        bot_messages_as_notices = true;
        bridge_notices = {
          default = false;
          exceptions = [ ];
        };
        command_prefix = "!tg";
        delivery_error_reports = true;
        delivery_receipts = false;
        displayname_max_length = 100;
        displayname_preference = [
          "full name"
          "username"
          "phone number"
        ];
        displayname_template = "'{displayname} (Telegram)'";
        emote_format = "'* $mention $formatted_body'";
        encryption = {
          allow = false;
          database = "default";
          default = false;
          key_sharing = {
            allow = false;
            require_cross_signing = false;
            require_verification = true;
          };
        };
        federate_rooms = true;
        filter = {
          list = [ ];
          mode = "blacklist";
        };
        image_as_file_size = 10;
        initial_power_level_overrides = {
          group = { };
          user = { };
        };
        inline_images = false;
        max_document_size = 100;
        max_initial_member_sync = 10;
        max_telegram_delete = 10;
        message_formats = {
          "m.audio" = "'<b>$sender_displayname</b> sent an audio file: $message'";
          "m.emote" = "'* <b>$sender_displayname</b> $message'";
          "m.file" = "'<b>$sender_displayname</b> sent a file: $message'";
          "m.image" = "'<b>$sender_displayname</b> sent an image: $message'";
          "m.location" = "'<b>$sender_displayname</b> sent a location: $message'";
          "m.notice" = "'<b>$sender_displayname</b>: $message'";
          "m.text" = "'<b>$sender_displayname</b>: $message'";
          "m.video" = "'<b>$sender_displayname</b> sent a video: $message'";
        };
        parallel_file_transfer = false;
        plaintext_highlights = false;
        private_chat_portal_meta = false;
        public_portals = true;
        relaybot = {
          authless_portals = true;
          group_chat_invite = [ ];
          ignore_own_incoming_events = true;
          ignore_unbridged_group_chat = true;
          private_chat = {
            invite = [ ];
            message = "This is a Matrix bridge relaybot and does not support direct chats";
            state_changes = true;
          };
          whitelist = [ ];
          whitelist_group_admins = true;
        };
        resend_bridge_info = false;
        skip_deleted_members = true;
        startup_sync = true;
        state_event_formats = {
          join = "<b>$displayname</b> joined the room.";
          leave = "<b>$displayname</b> left the room.";
          name_change = "<b>$prev_displayname</b> changed their name to <b>$displayname</b>";
        };
        sync_channel_members = false;
        sync_dialog_limit = 30;
        sync_direct_chats = false;
        sync_matrix_state = true;
        sync_with_custom_puppets = true;
        telegram_link_preview = true;
        username_template = "telegram_{userid}";

        permissions = {
          "${config.pub-solar-os.networking.domain}" = "full";
        };
      };

      logging = {
        formatters = {
          precise = {
            format = "[%(asctime)s] [%(levelname)s@%(name)s] %(message)s";
          };
        };
        handlers = {
          console = {
            class = "logging.StreamHandler";
            formatter = "precise";
          };
        };
        loggers = {
          aiohttp.level = "WARNING";
          mau.level = "WARNING";
          telethon.level = "WARNING";
        };
        root = {
          handlers = [ "console" ];
          level = "WARNING";
        };
        version = 1;
      };

      telegram = {
        connection = {
          flood_sleep_threshold = 60;
          request_retries = 5;
          retries = 5;
          retry_delay = 1;
          timeout = 120;
        };
        device_info = {
          app_version = "auto";
          device_model = "auto";
          lang_code = "en";
          system_lang_code = "en";
          system_version = "auto";
        };
        proxy = {
          address = "127.0.0.1";
          password = "''";
          port = 1080;
          rdns = true;
          type = "disabled";
          username = "''";
        };
        server = {
          dc = 2;
          enabled = false;
          ip = "149.154.167.40";
          port = 80;
        };
      };
    };
  };

  systemd.services.mautrix-telegram.path = with pkgs; [
    lottieconverter # for animated stickers conversion, unfree package
    ffmpeg # if converting animated stickers to webm (very slow!)
  ];
  systemd.services.mautrix-telegram.serviceConfig = {
    User = "matrix-synapse";
  };
}
