{
  config,
  lib,
  ...
}: {
  virtualisation.virtio.enable = true;
  networking.hostName = "neet-vm";

  disks = {
    deviceReference = "partuuid";

    devices = {
      main = {
        device = null;

        partitions = [
          # ESP / Boot (平文のまま)
          {
            name = "boot";
            size = "512M";
            content = {
              type = "vfat";
              label = "NEET_BOOT";
              mountPoint = "/boot";
              neededForBoot = true;
            };
          }

          # ★ LUKS 暗号化パーティション
          {
            name = "crypted"; # パーティション名
            size = "100%";
            content = {
              type = "luks";
              # 省略した場合は "crypt_<partition.name>" (ここでは "crypt_crypted") になります
              luksName = "cryptroot";

              # 暗号化コンテナの中に Btrfs を配置する
              content = {
                type = "btrfs";
                label = "NEET_OS";
                mountPoint = null;

                subvolumes = {
                  "@root" = {
                    mountPoint = "/";
                    options = ["compress=zstd"];
                    resetOnBoot = true;
                    keepOldRoots = 3;
                  };

                  "@nix" = {
                    mountPoint = "/nix";
                    options = ["compress=zstd"];
                  };

                  "@persist" = {
                    mountPoint = "/persist";
                    options = ["compress=zstd"];
                  };
                };
              };
            };
          }
        ];
      };
    };
  };

  impermanence = {
    enable = true;
    persistPath = "/persist";
    directories = [
      "/var/log"
      "/persist-test"
    ];
  };

  services.seatd = {
    enable = true;
    group = "seat";
    debug = true;
  };
}
