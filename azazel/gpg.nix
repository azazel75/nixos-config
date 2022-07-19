{ config, lib, pkgs, ... }: {
  programs.gpg = {
    enable = true;
    settings = {
      auto-key-locate = "local";
      default-key = "E3B5C55999D67CF9"; # key id from "gpg -K"
      keyserver = "hkp://keys.gnupg.net";
      use-agent = true;
      utf8-strings = true;
    };
  };
  services.gpg-agent = {
    enable = true;
    enableExtraSocket = true;
    enableSshSupport = true;
    extraConfig = ''  # cat ~/.gnupg/gpg-agent.conf
      allow-emacs-pinentry
    '';
    pinentryFlavor = "gnome3";
    sshKeys = [ # cat ~/.gnupg/sshcontrol
      #"7EA85C64EB4D4986403EDE66B54F0436AB0E86E6" # id_rsa
      #"8326866A208EA6D35030067A1810F5AD31CC8AA0" # id_ed25519
      #"7EA85C64EB4D4986403EDE66B54F0436AB0E86E6" # old gpg rsa2048
      "36CDC8D272500A1EB71C37661528E3F1D8270B69" # new gpg ed25519
      "BD8F54561247D1D291EF531D2AB81FC0F1B12FFC" # a.berti endian rsa4096
    ];
  };
}
