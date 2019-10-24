{pkgs, ... }:
  let
    nurBall = builtins.fetchTarball "https://github.com/nix-community/nur-combined/archive/master.tar.gz";
  in {
    nixpkgs.config.packageOverrides = pkgs: {
      nur = import nurBall {
        inherit pkgs;
      };
    };
  }
