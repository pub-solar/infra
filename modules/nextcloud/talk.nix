{
  config,
  lib,
  ...
}:
{
  options.pub-solar-os.nextcloud.talk =
    let
      inherit (lib) mkOption mkEnableOption types;
    in
    {
      enable = mkEnableOption ''
        Whether to enable the nextcloud talk module
      '';
      coturnStaticAuthSecretFile = mkOption {
        description = "File that holds the coturn static auth secret";
        type = types.str;
      };
      signalingSecretFile = mkOption {
        description = "File that holds the signaling server secret";
        type = types.str;
      };
    };

  config.systemd.services."nextcloud-talk-provisioning" =
    let
      occ = "/run/current-system/sw/bin/nextcloud-occ";
    in
    {
      serviceConfig.Type = "oneshot";
      wantedBy = [ "multi-user.target" ];

      after = [ "nextcloud-setup.service" ];
      script = ''
        TURN_SECRET=$(cat ${config.pub-solar-os.nextcloud.talk.coturnStaticAuthSecretFile})

        [ "''$(${occ} talk:turn:list | grep 'server:' | grep -c 'turn.${config.pub-solar-os.networking.domain}')" != "0" ] || \
          ${occ} talk:turn:add turns turn.${config.pub-solar-os.networking.domain} udp,tcp --secret $TURN_SECRET

        SIGNALING_SECRET=$(cat ${config.pub-solar-os.nextcloud.talk.signalingSecretFile})

        [ "''$(${occ} talk:signaling:list | grep 'server:' | grep -c 'signaling.${config.pub-solar-os.networking.domain}')" != "0" ] || \
          ${occ} talk:signaling:add https://signaling.${config.pub-solar-os.networking.domain} $SIGNALING_SECRET --verify
      '';
    };
}
