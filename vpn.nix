{ config, lib, pkgs, ... }:
 let
   etour = {
     address = "192.168.50.7/32";
     peer = "tricefalo";
     key = "/etc/nixos/secret/etour_key.priv";
   };
   dir-to-attrs = dirpath:
     with lib;
     flip mapAttrs (builtins.readDir dirpath)
       (name: _t: builtins.readFile (dirpath + ("/" + name)));
   tinc-net-hosts = netname:
     let
       netdir = ./tinc + ("/" + netname);
     in dir-to-attrs netdir;
 in {
   environment.systemPackages = with pkgs; [ tinc ];
    services.tinc.networks = {
      etour = {
        name = "ender";
        extraConfig = ''
          AddressFamily = ipv4
          ConnectTo = ${etour.peer}
          PrivateKeyFile = ${etour.key}
          Interface = tinc.etour
          Hostnames = yes
        '';
        chroot = false;
        debugLevel = 4;
        interfaceType = "tun";
        package = pkgs.tinc;
        hosts = tinc-net-hosts "etour";
      };
    };
    environment.etc =
      let
        inherit (pkgs) writeScript iproute;
        ip = "/run/wrappers/bin/sudo ${iproute + "/bin/ip"}";
      in {
        "tinc/etour/tinc-up".source = writeScript "tinc-up-etour" ''
          #!${pkgs.stdenv.shell}
          ${ip} link set $INTERFACE up
          ${ip} addr add ${etour.address} dev $INTERFACE
        '';
        "tinc/etour/tinc-down".source = writeScript "tinc-down-etour" ''
          #!${pkgs.stdenv.shell}
          ${ip} link set $INTERFACE down
        '';
        "tinc/etour/subnet-up".source = writeScript "tinc-subnet-up-et" ''
          #!${pkgs.stdenv.shell}
          ${ip} route add $SUBNET dev $INTERFACE
        '';
        "tinc/etour/subnet-down".source = writeScript "tinc-subnet-up-et" ''
          #!${pkgs.stdenv.shell}
          ${ip} route del $SUBNET dev $INTERFACE
        '';
      };
    security.sudo.extraRules = [{
      users    = [ "tinc.etour" ];
      commands = [{
        command  = pkgs.iproute + "/bin/ip";
        options  = [ "NOPASSWD" ];
      }];
    }];
    systemd.services."tinc.etour" = {
      wantedBy = lib.mkForce [];
    };
    security.polkit = {
      enable = true;
      extraConfig = ''
      // incredibly, this is JS
      // Allow azazel to manage tinc.etour.service;
      // fall back to implicit authorization otherwise.
      polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.systemd1.manage-units" &&
          action.lookup("unit") == "tinc.etour.service" &&
          subject.user == "azazel") {
          return polkit.Result.YES;
      });
      '';
    };
}
