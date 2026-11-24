{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-monochrome-emoji
    dejavu_fonts
    vim
    git
    foot
    kitty
  ];

  services.nix-daemon.package = pkgs.lix;
  services.iwd.enable = true;
  services.sshguard = {
    enable = false;
    whitelist = [];
  };
  networking.nftables = {
    enable = true;
    allowedTCPPorts = [22 80];
    allowedUDPPorts = [41641];
  };

  # サービス有効化
  services.sessiond-uaccess.enable = true;
  services.deviceManager = "mdevd";
  services.pipewire.enable = true;
  services.rtkit.enable = true;
  hardware.keyboard.keyMap = "jp106";
  neet.security.secrets.tools.enable = true;
  #boot.kernel.sysctl."vm.max_map_count" = 262144;
  #boot.secureBoot.enable = true;
  #boot.loader.limine.enable = true;
  boot.loader.efistub.enable = true;
  boot.uki.enable = true;
  programs.coreutils.package = pkgs.uutils-coreutils-noprefix;
  programs.wireplumber.enable = true;
  # ディスプレイマネージャ
  services.displayManager = {
    enable = true;
    provider = "greetd";
    defaultSession = "hyprland";
  };
  programs.sway.enable = true;
  programs.hyprland.enable = true;
  programs.neet-helper = {
    enable = true;
    flake = "/home/neet/NEET_dots";
  };
  hardware.graphics.enable = true;

  neet.security.privileges.backend = "doas";
}
