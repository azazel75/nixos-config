{ config, lib, pkgs, ... }:
  let
    keppel-share = name: {
      name = "/mnt/keppel/${name}";
      value = {
        device = "//nas/${name}";
        fsType = "cifs";
        options = [
          "noauto"
          "credentials=/etc/nixos/secret/keppel_samba.cred"
          "x-systemd.automount"
          "x-systemd.idle-timeout=5min"
          "uid=azazel"
          "gid=users"
        ];
      };
    };
    keppel-shares = names: builtins.listToAttrs (map keppel-share names);
  in {
    fileSystems = {
      "/mnt/giskard/data" = {
        device = "giskard:/mnt/data";
        fsType = "nfs";
        options = [
          "noauto"
          "x-systemd.automount"
          "x-systemd.idle-timeout=5min"
        ];
      };

      "/mnt/giskard/musica" = {
        device = "giskard:/mnt/musica";
        fsType = "nfs";
        options = [
          "noauto"
          "x-systemd.automount"
          "x-systemd.idle-timeout=5min"
        ];
      };

      "/mnt/giskard/books" = {
        device = "giskard:/mnt/books";
        fsType = "nfs";
        options = [
          "noauto"
          "x-systemd.automount"
          "x-systemd.idle-timeout=5min"
        ];
      };

      "/mnt/portable/sabrent1" = {
        device = "UUID=887c63c5-e9b4-4c87-b18f-2c521c27f715";
        fsType = "btrfs";
        options = [
          "noatime"
          "noauto"
          "x-systemd.automount"
          "x-systemd.idle-timeout=5min"
        ];
      };

      "/mnt/portable/samsung" = {
        device = "UUID=df6cab1a-128d-4a6c-89fe-64b5ee54d1fd";
        fsType = "ext4";
        options = [
          "noatime"
          "noauto"
          "x-systemd.automount"
          "x-systemd.idle-timeout=5min"
        ];
      };
    } // (keppel-shares ["azazel" "download" "keppel" "scansioni"]);
  }
