{ config, pkgs, ... }:

let
  powercord-overlay = import (builtins.fetchTarball "https://github.com/LavaDesu/powercord-overlay/archive/master.tar.gz");
  moz_overlay = import (builtins.fetchTarball "https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz");
in
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [ powercord-overlay.overlay moz_overlay ];

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "bs2k";
  home.homeDirectory = "/home/bs2k";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  home.packages = [
    pkgs.kate
    pkgs.git
    pkgs.nerdfonts
    pkgs.discord-plugged
    pkgs.firefox
    pkgs.onlykey-cli
    pkgs.keepassxc
    pkgs.yakuake
    pkgs.latest.rustChannels.stable.rust
    pkgs.polymc
  ];

  services.syncthing = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "zsh-users/zsh-completions"; }
        { name = "chisui/zsh-nix-shell"; }
        { name = "zsh-users/zsh-syntax-highlighting"; tags = [ defer:2 ]; }
      ];
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
        window.dimensions = {
          columns = 80;
          lines = 24;
        };
        font.normal.family = "Hack Nerd Font";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      matklad.rust-analyzer
      tamasfe.even-better-toml
      coenraads.bracket-pair-colorizer-2
      github.copilot
      jnoortheen.nix-ide
    ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
