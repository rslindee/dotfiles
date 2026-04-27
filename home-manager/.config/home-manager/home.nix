{ config, pkgs, ...}: 
{
  home.username = "rslindee";
  home.homeDirectory = "/home/rslindee";
  home.stateVersion = "25.11";

  targets.genericLinux.enable = true;

  home.packages = with pkgs; [
    curl
    direnv
    fd
    fzf
    jdk
    jq
    mosquitto
    protols
    ripgrep
    tmux
    tree-sitter
  ];
  programs.direnv.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user = {
        name  = "Richard Slindee";
        email = "rslindee@ford.com";
      };
    };
    includes = [
      { path = "~/dotfiles/git/.config/git/config"; }
    ];
  };

  programs.diff-highlight = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.neovim = {
    enable = true;
    extraConfig = ''
      luafile ~/dotfiles/nvim/.config/nvim/init.lua
    '';
  };

  programs.zsh = {
    enable = true;
    initContent = ''
      source ~/dotfiles/zsh/.zshrc
    '';
    enableCompletion = true;
    syntaxHighlighting.enable = true;
  };

  programs.home-manager.enable = true;
}

