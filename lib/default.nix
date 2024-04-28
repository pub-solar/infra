{
  self,
  lib,
  inputs,
  ...
}:
{
  # Configuration common to all Linux systems
  flake = {
    lib = let
        callLibs = file: import file { inherit lib; };
      in
      rec {
        ## Define your own library functions here!
        #id = x: x;
        ## Or in files, containing functions that take {lib}
        #foo = callLibs ./foo.nix;
        ## In configs, they can be used under "lib.our"

        deploy = import ./deploy.nix { inherit inputs lib; };
      };
  };
}
