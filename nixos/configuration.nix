# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and on the NixOS manual (`nixos-help`).

{ config, lib, pkgs, nixpkgs-unstable, ... }:

let unstable = import nixpkgs-unstable {
  system = pkgs.system;
  config.allowUnfree = true;
};
in 
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nvidia.nix
    ];

  fileSystems."/mnt/tmp-win-efi" = {
    device = "/dev/nvme0n1p1";
    fsType = "vfat";
    options = [ "ro" ];
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    #systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      configurationLimit = 10;
    };
  };

  boot.blacklistedKernelModules = [ "nouveau" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  # waybar 的 bluetooth 模块与 niri spawn 的 blueman-applet 依赖 BlueZ
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  # See nvidia.nix
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  programs.gamemode.enable = true;
  programs.xwayland.enable = true;
  programs.niri.enable = true;
  programs.gamescope.enable = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Networking
  networking.hostName = "shinomiya";
  networking.networkmanager.enable = true;
  /*
  networking.firewall = {
    enable = true;

    allowedTCPPorts = [ 20170 20171 20172];
    allowedUDPPorts = [ 20170 20171 20172];

    checkReversePath = false;
  };
  */
  /*
  networking.proxy = {
    default = "http://127.0.0.1:20171";
    noProxy = "127.0.0.1,localhost,*.local,*.internal,internal.domain";
  };
  */

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "zh_CN.UTF-8";

  # 输入法：fcitx5（GTK/Qt/Wayland 的 IM 环境变量由该模块统一设置）
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [ qt6Packages.fcitx5-chinese-addons ];
  };

  fonts.packages = with pkgs; [
    # LXGW (霞鹜)
    lxgw-wenkai
    lxgw-wenkai-screen
    lxgw-neoxihei
    # Noto CJK
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    # Source Han
    source-han-sans
    source-han-serif
    # Monospace / Coding
    julia-mono
    jetbrains-mono
    fira-code
    fira-code-symbols
    # 打过补丁的 Nerd Font：waybar 图标与文字同一 em 度量
    nerd-fonts.jetbrains-mono
  ];

  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = false;
  services.v2raya.enable = true;
  # brightnessctl 自带 90-brightnessctl.rules：backlight/LED 节点 chgrp video + g+w
  services.udev.packages = [ pkgs.brightnessctl ];

  services.displayManager.ly.enable = true;
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;

      PermitRootLogin = "no";
      
      MaxAuthTries = 7;
    };
  };
  
  zramSwap.enable = true;
  nix.settings.experimental-features = ["nix-command" "flakes" ];
  nix.settings.substituters = [
    "https://mirror.sjtu.edu.cn/nix-channels/store"
    "https://cache.nixos.org/"
  ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  # Fuck NVIDIA
  nixpkgs.config.allowUnfree = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Sound
  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    jack.enable = false;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  users.users.amiriox = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "video" "render" "input"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
      firefox
      kitty
      swaybg
      rofi
      waybar
      playerctl
      wl-clipboard
      cliphist
      pkgs.claude-code
      pkgs.codex
      unstable.cc-switch
      (pkgs.writeShellScriptBin "br" ''
        val="$1"
        case "$val" in
          -* ) val="''${val#-}-" ;;
        esac
        exec ${pkgs.brightnessctl}/bin/brightnessctl -q s "$val"
      '')
    ];
  };
  
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    alacritty
    fuzzel
    waybar
    swaybg
    dunst
    libnotify
    vim
    neovim
    wget
    curl
    tree
    fastfetch
    btop
    ripgrep
    git
    zsh
    zenity
    mangohud
    xwayland-satellite
    brightnessctl
    # Dev tools
    gcc
    clang
    cmake
    gdb
    rustup
    # weather.py 需要 requests
    (python3.withPackages (ps: [ ps.requests ]))
    ffmpeg
    jq
    fzf
    # Neovim / toolchain support
    gnumake
    unzip
    tree-sitter
    stylua
    black
    clang-tools
    fd
  ];

  # Run prebuilt binaries (e.g. rustup toolchains)
  programs.nix-ld.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;

    ohMyZsh = {
      enable = true;
      plugins = [ "git" "sudo" "z" ];
      theme = "lmy";
      custom = "/home/amiriox/.oh-my-zsh/custom";
    };
  };
  
  programs.ssh = {	
    # startAgent = true; # fuck gnome
    enableAskPassword = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a newer NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does not mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}
