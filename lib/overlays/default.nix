_:
let
  nhLatestOverlay =
    _: p:
    let
      targetVersion = "4.0.1";
      version =
        if (builtins.compareVersions p.nh.version targetVersion) >= 0 then
          throw "nhLatestOverlay needs to be removed, nh version with hm sp support available ${p.nh.version}"
        else
          "4.0.2";
      src = p.fetchFromGitHub {
        owner = "viperML";
        repo = "nh";
        tag = "refs/tags/v${version}";
        hash = "sha256-ajEl9nV4XFW7H98XCPUshzYL+K0+gVqEWUC4+MBAUFw=";
      };
    in
    {
      nh = p.nh.overrideAttrs (_: {
        inherit version src;
        cargoDeps = p.rustPlatform.fetchCargoVendor {
          inherit src;
          hash = "sha256-MqvYDCtj6omYpwhKvWkI5CRz8ZpT8OLj7SazJUzVtc8=";
        };
      });
    };
in
[ nhLatestOverlay ]
