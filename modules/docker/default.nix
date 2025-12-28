{ pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;
    package = pkgs.docker_29;
    autoPrune.enable = true;
    extraOptions = ''
      --data-root /var/lib/docker
    '';
    storageDriver = "zfs";
  };

  networking.firewall.trustedInterfaces = [ "docker0" ];
}
