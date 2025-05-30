{ pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
    extraOptions = ''
      --data-root /var/lib/docker
    '';
    storageDriver = "zfs";
  };

  networking.firewall.trustedInterfaces = [ "docker0" ];
}
