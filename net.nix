{config, pkgs, lib, ...}:
  let
    hostName = config.networking.hostName;
  in {
    networking = rec {
      domain = "lan";
      search = [ "lan" ];
      enableIPv6 = false;
      hosts = {
        "127.0.0.1" = [ "${hostName}.${domain}" "${hostName}" "localhost" ];
        "172.21.200.133" = ["intranet.apss.tn.it" "intranet"];
        "172.21.210.84" = ["intranet-new.apss.tn.it" "intranet-new"];
        "151.101.242.217" = ["cache.nixos.org"];
      };
    # extraHosts = lib.readFile ./ads-hosts;
    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
      networkmanager = {
        enable = true;
        enableStrongSwan = true;
        plugins = with pkgs; [
          networkmanager-openvpn
        ];
        wifi = {
          powersave = true;
        };
      };
      # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
      firewall.enable = false;
    };
    services.samba = {
      enable = true;
      shares = {
          public = {
            browseable = "yes";
            comment = "Public samba share.";
            "guest ok" = "yes";
            path = "/srv/public";
            "read only" = true;
          };
      };
    };
}
