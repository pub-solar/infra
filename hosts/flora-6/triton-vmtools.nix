{
  pkgs,
  flake,
  ...
}: {
  environment.systemPackages = with pkgs; [
    flake.inputs.triton-vmtools.packages.${pkgs.system}.default
  ];
}
