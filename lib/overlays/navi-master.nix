_: p: {
  navi = p.navi.overrideAttrs (old: rec {
    pname = "navi";
    version = "master";
    src = p.fetchFromGitHub {
      owner = "denisidoro";
      repo = "navi";
      rev = version;
      hash = "sha256-h7lF+jvrwjiMMmaqOGifJnBbTgjCK0WW2yocq7vO7zU=";
    };
    cargoDeps = old.cargoDeps.overrideAttrs (
      p.lib.const {
        name = "${pname}-vendor.tar.gz";
        inherit src;
        outputHash = "sha256-vNfcSHNP0KNM884DMtraYohLOvumSZnEtemJ+bJSQ5o=";
      }
    );
  });
}
