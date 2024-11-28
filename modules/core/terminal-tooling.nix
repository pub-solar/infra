{ flake, lib, ... }:
{
  home-manager.users = (
    lib.attrsets.foldlAttrs (
      acc: name: value:
      acc
      // {
        ${name} = {
          programs.git.enable = true;
          programs.starship.enable = true;
          programs.bash.enable = true;
          programs.neovim = {
            enable = true;
            vimAlias = true;
            viAlias = true;
            defaultEditor = true;
            # configure = {
            #   packages.myVimPackages = with pkgs.vimPlugins; {
            #     start = [vim-nix vim-surrund rainbow];
            #   };
            # };
          };
        };
      }
    ) { } flake.self.logins.admins
  );
}
