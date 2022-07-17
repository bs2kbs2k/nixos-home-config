{ config, pkgs, ... }:

let
  powercord-overlay = import (builtins.fetchTarball "https://github.com/LavaDesu/powercord-overlay/archive/master.tar.gz");
  moz_overlay = import (builtins.fetchTarball "https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz");
  rust = pkgs.latest.rustChannels.stable.rust.override {
    targets = [ "x86_64-unknown-linux-musl" "thumbv7em-none-eabihf" ];
  };
  nix-alien-pkgs = import (
    fetchTarball "https://github.com/thiagokokada/nix-alien/tarball/master"
  ) { };
  secrets = import ./secrets.nix;
in
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    powercord-overlay.overlay
    moz_overlay
    (self: super: {
      discord-canary = super.discord-canary.override {
        nss = pkgs.nss_latest;
      };
    })
  ];

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

  home.packages = with nix-alien-pkgs; [
    rust
    pkgs.musl
    pkgs.musl.dev
    
    pkgs.kate
    pkgs.git
    pkgs.nerdfonts
    pkgs.discord-plugged
    pkgs.firefox
    pkgs.onlykey-cli
    pkgs.keepassxc
    pkgs.yakuake
    pkgs.polymc
    pkgs.nanum
    pkgs.thunderbird
    pkgs.ckan
    pkgs.libsForQt5.ark
    pkgs.kicad
    pkgs.eagle
    pkgs.gcc
    pkgs.openocd
    pkgs.blender
    pkgs.godot
    pkgs.tiled
    pkgs.thefuck

    nix-alien
    nix-index-update
    pkgs.nix-index

    (import (fetchGit "https://github.com/haslersn/fish-nix-shell"))
  ];

  services.syncthing = {
    enable = true;
  };

  services.spotifyd = {
    enable = true;
    settings = {
      global = {
        username = "31dohyohht5s5rb7xq4vfw6ihomq";
        password = secrets.spotify_password;
        bitrate = 320;
        device_type = "computer";
        device_name = "chell";
      };
    };
  };

  programs.zsh = {
    enable = true;
    autocd = true;
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

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      fish-nix-shell | source
      thefuck --alias | source
    '';
    functions = {
      fish_greeting = ''
      curl wttr.in/\?0
      '';
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
    enableFishIntegration = true;
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      matklad.rust-analyzer
      tamasfe.even-better-toml
      coenraads.bracket-pair-colorizer-2
      jnoortheen.nix-ide
    ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
