{
  config,
  pkgs,
  flake,
  ...
}:
{
  services.nginx = {
    defaultSSLListenPort = 8443;
  };
}
