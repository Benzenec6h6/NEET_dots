{
  description = "NEET OS Configuration & Dotfiles";

  inputs = {
    neet-os.url = "github:Benzenec6h6/NEET_OS";
  };

  outputs = {
    self,
    neet-os,
  }: let
    # NEET_OS 側のヘルパーを使って VM 設定を評価
    vmSystem = neet-os.lib.evalSystem [
      ./configuration.nix
      ./profiles/vm-qemu/default.nix
    ];
  in {
    # VM の起動: nix run .
    apps.x86_64-linux.default = {
      type = "app";
      program = "${vmSystem.config.system.build.vm}/bin/run-vm";
    };

    # 各種ビルド成果物
    packages.x86_64-linux = {
      # default は OS の中身 (toplevel) にする
      default = vmSystem.config.system.build.toplevel;
      toplevelVm = vmSystem.config.system.build.toplevel;

      # ディスクイメージは明示的に vmImage とする
      vmImage = vmSystem.config.system.build.diskImage;
    };
  };
}
