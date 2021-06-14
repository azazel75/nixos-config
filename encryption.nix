{config, pkgs, lib, ...}: {
  # Self-encrypting drive (OPAL)
  nixpkgs.config.packageOverrides = pkgs: {
    sedutil = (pkgs.sedutil.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or []) ++ [
        # Add support for enabling unlocking when resuming from sleep
        # See: https://github.com/Drive-Trust-Alliance/sedutil/pull/190
        (builtins.fetchurl {
          url = https://patch-diff.githubusercontent.com/raw/Drive-Trust-Alliance/sedutil/pull/190.patch;
          sha256 = "c0618a319eb0c9a6efe9c72db59338232b235079042ccf77b1d690f64f735a42";
        })
      ];
    }));
  };

  environment.systemPackages = [ pkgs.sedutil ];

  # NOTE: Generate the password hash with: sudo sedutil-cli --printPasswordHash 'plaintext-password-here' /dev/nvme0n1
  systemd.services.sedutil-s3sleep =
    let
      opalPasswordHash = lib.readFile ./secret/opal_password_hash;
    in {
    description = "Enable S3 sleep on OPAL self-encrypting drives";
    documentation = [ "https://github.com/Drive-Trust-Alliance/sedutil/pull/190" ];
    path = [ pkgs.sedutil ];
    script = "sedutil-cli -n -x --prepareForS3Sleep 0 ${opalPasswordHash} /dev/nvme0n1";
    wantedBy = [ "multi-user.target" ];
  };
}
