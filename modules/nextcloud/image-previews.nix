{
  config,
  pkgs,
  flake,
  lib,
  ...
}:
{
  # https://docs.nextcloud.com/server/30/admin_manual/installation/server_tuning.html#previews
  services.imaginary = {
    enable = true;
    address = "127.0.0.1";
    settings.return-size = true;
  };

  systemd = {
    services =
      let
        occ = "/run/current-system/sw/bin/nextcloud-occ";
        inherit (config.systemd.services.nextcloud-setup.serviceConfig) LoadCredential;
      in
      {
        nextcloud-cron-preview-generator = {
          environment.NEXTCLOUD_CONFIG_DIR = "${config.services.nextcloud.home}/config";
          serviceConfig = {
            inherit LoadCredential;
            ExecStart = "${occ} preview:pre-generate";
            Type = "oneshot";
            User = "nextcloud";
          };
        };

        nextcloud-preview-generator-setup = {
          wantedBy = [ "multi-user.target" ];
          requires = [ "phpfpm-nextcloud.service" ];
          after = [ "phpfpm-nextcloud.service" ];
          environment.NEXTCLOUD_CONFIG_DIR = "${config.services.nextcloud.home}/config";
          script = # bash
            ''
              # check with:
              # for size in squareSizes widthSizes heightSizes; do echo -n "$size: "; sudo nextcloud-occ config:app:get previewgenerator $size; done

              # extra commands run for preview generator:
              # 32   icon file list
              # 64   icon file list android app, photos app
              # 96   nextcloud client VFS windows file preview
              # 256  file app grid view, many requests
              # 512  photos app tags
              ${occ} config:app:set --value="32 64 96 256 512" previewgenerator squareSizes

              # 341 hover in maps app
              # 1920 files/photos app when viewing picture
              ${occ} config:app:set --value="341 1920" previewgenerator widthSizes

              # 256 hover in maps app
              # 1080 files/photos app when viewing picture
              ${occ} config:app:set --value="256 1080" previewgenerator heightSizes
            '';
          serviceConfig = {
            inherit LoadCredential;
            Type = "oneshot";
            User = "nextcloud";
          };
        };
      };
    timers.nextcloud-cron-preview-generator = {
      after = [ "nextcloud-setup.service" ];
      timerConfig = {
        OnCalendar = "*:0/10";
        OnUnitActiveSec = "9m";
        Persistent = true;
        RandomizedDelaySec = 60;
        Unit = "nextcloud-cron-preview-generator.service";
      };
      wantedBy = [ "timers.target" ];
    };
  };
}
