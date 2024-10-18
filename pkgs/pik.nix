# nix-init, immaculate
{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "pik";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "jacek-kurlit";
    repo = "pik";
    rev = version;
    hash = "sha256-YAnMSVQu/E+OyhHX3vugfBocyi++aGwG9vF6zL8T2RU=";
  };

  cargoHash = "sha256-a7mqtxZMJl8zR8oCfuGNAiT5MEAmNpbDLSgi8A6FfPA=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.IOKit
  ];

  meta = {
    description = "Process Interactive Kill";
    homepage = "https://github.com/jacek-kurlit/pik";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ phanirithvij ];
    mainProgram = "pik";
  };
}
