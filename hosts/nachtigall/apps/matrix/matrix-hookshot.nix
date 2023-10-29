{ flake, pkgs, ...}:{

  age.secrets."matrix-hookshot-registration.yaml" = {
    file = "${flake.self}/secrets/matrix-hookshot-registration.yaml.age";
    mode = "400";
    owner = "matrix-synapse";
  };

  configFile = ''
    bot:
      avatar: mxc://half-shot.uk/2876e89ccade4cb615e210c458e2a7a6883fe17d
      displayname: Hookshot Bot
    bridge:
      bindAddress: 0.0.0.0
      domain: test.pub.solar
      mediaUrl: http://matrix-nginx-proxy:12080
      port: 9993
      url: http://matrix-nginx-proxy:12080
    feeds:
      enabled: true
      pollIntervalSeconds: 600
      pollTimeoutSeconds: 30
    generic:
      allowJsTransformationFunctions: true
      enableHttpGet: false
      enabled: true
      urlPrefix: https://matrix.test.pub.solar/hookshot/webhooks
      userIdPrefix: _webhooks_
      waitForComplete: false
    gitlab:
      instances:
        gitlab.com:
          url: https://gitlab.com
      webhook:
        secret: ""
    listeners:
    - bindAddress: 0.0.0.0
      port: 9000
      resources:
      - webhooks
    - bindAddress: 0.0.0.0
      port: 9002
      resources:
      - provisioning
    - bindAddress: 0.0.0.0
      port: 9003
      resources:
      - widgets
    logging:
      level: warn
    metrics:
      enabled: false
    passFile: /data/passkey.pem
    permissions:
    - actor: pub.solar
      services:
      - level: commands
        service: '*'
    - actor: '@axeman:pub.solar'
      services:
      - level: admin
        service: '*'
    - actor: '@b12f:pub.solar'
      services:
      - level: admin
        service: '*'
    - actor: '@hensoko:pub.solar'
      services:
      - level: admin
        service: '*'
    - actor: '@teutat3s:pub.solar'
      services:
      - level: admin
        service: '*'
    provisioning:
      secret: 1acb44197a5a6d52c6cff38ea07433bfbfe9a83313a6bade
    widgets:
      addToAdminRooms: false
      branding:
        widgetTitle: Hookshot Configuration
      publicUrl: https://matrix.pub.solar/hookshot/widgetapi/v1/static
      roomSetupWidget:
        addOnInvite: false
  '';

  systemd.services.matrix-hookshot = {
    description = "Matrix-Hookshot,  a bridge between Matrix and multiple project management services, such as GitHub, GitLab and JIRA. ";

    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];

    serviceConfig = {
      Type = "simple";
      Restart = "always";

      ProtectSystem = "strict";
      ProtectHome = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;

      DynamicUser = true;
      PrivateTmp = true;
      UMask = "0027";

      ExecStart = ''
          ${pkgs.matrix-hookshot}/bin/matrix-hookshot
        '';
    };
  };
}
