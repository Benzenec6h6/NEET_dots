{
  pkgs,
  lib,
  ...
}: {
  environment.systemPackages = [
    pkgs.fontconfig
    pkgs.dejavu_fonts
    pkgs.git
  ];

  services.iwd.enable = true;
  services.openssh = {
    enable = true;
    startOnBoot = false;
  };
  services.sshguard = {
    enable = false;
    whitelist = [];
  };
  networking.nftables = {
    enable = true;
    tables.filter = {
      family = "inet"; # IPv4 と IPv6 の両方を 1 つのテーブルで扱う
      content = ''
        chain input {
          # 基本方針: 許可したもの以外はすべて破棄 (drop)
          # priority 0 (filter) で動作
          type filter hook input priority 0; policy drop;

          # 1. ループバック (localhost) からの通信は無条件で許可
          iifname "lo" accept

          # 2. 既に確立された通信 (established) や関連パケット (related) は許可
          # (これがないと、自分から外に出したリクエストの返事を受け取れません)
          ct state { established, related } accept

          # 3. 破損した不正パケットは破棄
          ct state invalid drop

          # 4. ICMP (ping) を許可
          ip protocol icmp accept
          ip6 nexthdr icmpv6 accept

          # 5. SSH (ポート 22) の接続を許可
          tcp dport 22 accept
        }

        chain forward {
          # ルーター動作はしないので通過パケットはすべて破棄
          type filter hook forward priority 0; policy drop;
        }

        chain output {
          # 自分が外に出ていく通信はすべて許可
          type filter hook output priority 0; policy accept;
        }
      '';
    };
  };

  # サービス有効化
  #services.sessiond.debug = true;
  #services.sessiond-uaccess.enable = true;
  services.deviceManager = "mdevd";
  services.pipewire.enable = true;
  services.rtkit.enable = true;
  neet.security.enable = true;
  #boot.loader.limine.enable = true;
  boot.loader.efistub.enable = true;
  boot.uki.enable = true;
  boot.console.keyMap = "jp106";
  #boot.kernel.sysctl."vm.max_map_count" = 262144;
  programs.coreutils.package = pkgs.uutils-coreutils-noprefix;
  programs.wireplumber.enable = true;

  neet.security.privileges.backend = "doas";

  neet.users = {
    root = {
      uid = 0;
      gid = 0;
      shell = "/bin/bash";
      home = "/root";
      description = "System Administrator";
      initialHashedPassword = "$y$j9T$lwc.8Oc5W7OwTWLCfDmfw/$IA4QRTrN.yPQcPwIiF8UULTrTDA3nZTM0p1JmQj/Jw4";
    };
    neet = {
      uid = 1000;
      gid = 1000;
      shell = "/bin/bash";
      home = "/home/neet";
      description = "Primary User";
      extraGroups = ["audio" "video" "input" "seat" "wheel"];
      initialHashedPassword = "$y$j9T$lwc.8Oc5W7OwTWLCfDmfw/$IA4QRTrN.yPQcPwIiF8UULTrTDA3nZTM0p1JmQj/Jw4";
    };
  };
}
