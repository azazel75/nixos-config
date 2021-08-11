# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./boot.nix
      ./net.nix
      ./packages.nix
      ./tlp.nix
      # ./encryption.nix
      ./vpn.nix
      ./xorg.nix
      ./wayland.nix
      ./window_system.nix
      ./mounts.nix
      ./sleep.nix
    ];

  console = {
    keyMap = "it";
  };

  #Select internationalisation properties.
  i18n.defaultLocale = "it_IT.UTF-8";

  environment.homeBinInPath = true;
  location = import ./secret/location.nix;
  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.adb.enable = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.avahi = {
    enable = true;
    nssmdns = true;
  };
  services.connman.enable = false;

  #services.teamviewer.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;


  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
    ];
  };
  services.hardware.bolt.enable = true;
  services.gvfs.enable = true;

  sound.mediaKeys = {
    enable = true;
    volumeStep = "5%";
  };
  services.illum.enable = true;
  services.redshift.enable = true;


  services.pcscd.enable = true;
  services.pcscd.plugins = [ pkgs.ccid pkgs.libacr38u];
  services.fwupd.enable = true;
  services.fstrim.enable = true;

  users.users.azazel = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "docker" "vboxusers" "cdrom" "video" "libvirtd"
                    "scanner" "lp" ];
    createHome = true;
    description = "Alberto Berti";
  };

  virtualisation = {
    virtualbox.host = {
      enable = true;
      enableExtensionPack = false;
    };
    docker = {
      enable = true;
      extraOptions = lib.concatStringsSep " " [
        "--insecure-registry=10.4.0.76" # E.'s internal registry
      ];
    };
    libvirtd = {
      enable = false;
    };
  };
  services.printing.enable = true;

  services.journald.extraConfig = ''
    MaxRetentionSec = 4 month
  '';

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    trustedUsers = [ "root" "azazel" ];
    useSandbox = "relaxed";
  };
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.libvirt.unix.manage" && subject.local && subject.active && subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';
  # fix issues with k3d and docker
  # See https://github.com/rancher/k3d/issues/493#issuecomment-814290147
  systemd.enableUnifiedCgroupHierarchy = false;
}
