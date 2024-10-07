_: p: {
  navi = p.navi.overrideAttrs (old: rec {
    pname = "navi";
    version = "master";
    src = p.fetchFromGitHub {
      owner = "denisidoro";
      repo = "navi";
      rev = version;
      hash = "sha256-/pVE5C9c9R+1CANnCVJddc0kFJlREBl9ULET773edJo=";
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
