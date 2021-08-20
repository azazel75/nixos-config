# alternative package for the Nyxt web browser, fresher
{ cl-webkit2
, fetchFromGitHub
, nyxt
}:
 {
   cl-webkit2 = cl-webkit2.overrideAttrs (oldAttrs:
     {
       src = fetchFromGitHub {
         owner = "joachifm";
         repo = "cl-webkit";
         rev = "90b1469713265096768fd865e64a0a70292c733d";
         sha256 = "sha256:0lxws342nh553xlk4h5lb78q4ibiwbm2hljd7f55w3csk6z7bi06";
       };
     });
   nyxt = nyxt.overrideAttrs (oldAttrs:
     {
       version = "2.1.1";
       src = fetchFromGitHub {
         owner = "atlas-engineer";
         repo = "nyxt";
         rev = "93a2af10f0b305740db0a3232ecb690cd43791f9";
         sha256 = "sha256-GdTOFu5yIIL9776kfbo+KS1gHH1xNCfZSWF5yHUB9U8=";
       };
     });
}
