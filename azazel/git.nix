{ config, lib, pkgs, ... }: {
  programs.git = {
    enable = true;
    aliases = {
      ci = "commit";
      co = "checkout";
      st = "status";
      sum = "log --graph --decorate --oneline --color --all";
    };
    delta.enable = true;
    extraConfig = {
      color.ui = "auto";
      pull.rebase = "false";
    };
    includes = [{
      condition = "gitdir:~/wip/endian/**";
      contents = { user.email = "a.berti@endian.com"; };
    }];
    userName = "Alberto Berti";
    userEmail = "alberto@metapensiero.it";
  };
}
