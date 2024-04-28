{ ... }:
{
  services.tmate-ssh-server = {
    enable = true;
    port = 2222;
    openFirewall = true;
    host = "tmate.pub.solar";
  };
}
