{ config, ... }:
{
  services.tmate-ssh-server = {
    enable = true;
    port = 2222;
    openFirewall = true;
    host = "tmate.${config.pub-solar-os.networking.domain}";
  };
}
