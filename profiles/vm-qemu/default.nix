{...}: {
  imports = [
    ./disk.nix
    ./impermanence.nix
  ];
  virtualisation.virtio.enable = true;
  boot.vt.enable = true;
  boot.serial.enable = true;
  boot.primaryConsole = "serial";
  services.openssh = {
    enable = true;
    startOnBoot = false;
    settings = {
      PermitRootLogin = "yes";
    };
  };
  networking.hostName = "neet-vm";
}
