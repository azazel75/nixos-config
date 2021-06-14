{ config, lib, pkgs, ... }: {
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    efiSupport = true;
    enable = true;
    device = "nodev";
    useOSProber = true;
  };
}
