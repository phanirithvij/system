{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gomtree";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "vbatts";
    repo = "go-mtree";
    rev = "v${version}";
    hash = "sha256-MDX16z4H1fyuV5atEsZHReJyvC+MRdeA54DORCFtpqI=";
  };

  vendorHash = null;

  # tests fail with only on nix due to file ro-system
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "File systems verification utility and library, in likeness of mtree(8)";
    homepage = "https://github.com/vbatts/go-mtree";
    license = licenses.bsd3;
    maintainers = with maintainers; [ phanirithvij ];
    mainProgram = "gomtree";
  };
}
