{
  description = "NEET OS Configuration & Dotfiles";

  inputs = {
    neet-os.url = "github:Benzenec6h6/NEET_OS/refactor/rename";
  };

  outputs = {
    self,
    neet-os,
    ...
  }: let
    vmSystem = neet-os.lib.evalSystem [
      ./configuration.nix
      ./profiles/vm-qemu/default.nix
    ];
  in {
    # ★ これを outputs 直下に定義する（.#neet-vm で呼べるようにする）
    neet-vm = vmSystem.config;

    apps.x86_64-linux.default = {
      type = "app";
      program = "${vmSystem.config.system.build.vm}/bin/run-vm";
    };

    packages.x86_64-linux = {
      default = vmSystem.config.system.build.toplevel;
      toplevelVm = vmSystem.config.system.build.toplevel;
    };
  };
}
