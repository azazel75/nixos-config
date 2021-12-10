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
      ./encryption.nix
      ./vpn.nix
      ./xorg.nix
      ./window_system.nix
      ./mounts.nix
      ./sleep.nix
    ];

  console = {
    keyMap = "it";
  };

  environment.homeBinInPath = true;

  #Select internationalisation properties.
  i18n.defaultLocale = "it_IT.UTF-8";
  location = import ./secret/location.nix;

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    trustedUsers = [ "root" "azazel" ];
    useSandbox = "relaxed";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.adb.enable = true;
  programs.mtr.enable = true;

  # Enable sound.
  sound = {
    enable = true;
    mediaKeys = {
      enable = true;
      volumeStep = "5%";
    };
  };

  services = {
    avahi = {
      enable = true;
      nssmdns = true;
    };
    blueman.enable = true;
    connman.enable = false;
    dbus.packages = [ pkgs.gcr ]; # for gnome3 pinentry
    fstrim.enable = true;
    fwupd.enable = true;
    gvfs.enable = true;
    hardware.bolt.enable = true;
    illum.enable = true;
    journald.extraConfig = ''
      MaxRetentionSec = 4 month
      '';
    openssh.enable = true;
    pcscd.enable = true;
    pcscd.plugins = [ pkgs.ccid pkgs.libacr38u];
    # see https://nixos.wiki/wiki/Firefox
    pipewire.enable = true;
    printing.enable = true;
    redshift.enable = !config.system.useWayland;
    # teamviewer.enable = true;
  };

  systemd.enableUnifiedCgroupHierarchy = true;
  # rootless containers https://rootlesscontaine.rs/getting-started/common/cgroup2/#enabling-cpu-cpuset-and-io-delegation
  systemd.services."user@".serviceConfig = {
    Delegate = "cpu cpuset io memory pids";
  };
  # Set your time zone.
  time.timeZone = "Europe/Rome";

  users.users.azazel = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "docker" "vboxusers" "cdrom" "video" "libvirtd"
                    "scanner" "lp" "i2c" "input" ];
    createHome = true;
    description = "Alberto Berti";
  };

  virtualisation = {
    spiceUSBRedirection.enable = true;
    virtualbox.host = {
      enable = false;
      enableExtensionPack = false;
    };
    docker = {
      enable = true;
      extraOptions = lib.concatStringsSep " " [
        "--insecure-registry=10.4.0.76" # E.'s internal registry
      ];
    };
    libvirtd = {
      enable = true;
    };
    podman = {
      enable = true;
    };
    anbox.enable = false;
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
      gtkUsePortal = true;
      wlr = {
        enable = true;
      };
    };
  };
}
