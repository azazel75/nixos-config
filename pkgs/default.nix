self: super: {
  lispPackages = super.lispPackages // (import ./nyxt2.nix {
    inherit (super.lispPackages) cl-webkit2 nyxt;
    inherit (super) fetchFromGitHub;
  });
}
