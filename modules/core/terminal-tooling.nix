{ flake, config, ... }: {
  home-manager.users.${config.pub-solar-os.authentication.username} = {
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
