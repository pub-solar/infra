{lib, ...}:
{
  flake = {
    publicKeys = {
      allAdmins = lib.attrsets.attrValues (import ./admins.nix); 
    };
  };
}
