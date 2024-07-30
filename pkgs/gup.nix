{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gup";
  version = "0.27.3";

  src = fetchFromGitHub {
    owner = "nao1215";
    repo = "gup";
    rev = "v${version}";
    hash = "sha256-8DtD22kvGez2iX0VqoZ1zSydcNYnDz3r698nXEwtoZE=";
  };

  vendorHash = "sha256-yqCmo33ihkaPK8iL5cnCIGbOLkdXjuIWLwtgAa+KB8Y=";
  doCheck = false;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "gup - Update binaries installed by 'go install' with goroutines.";
    homepage = "https://github.com/nao1215/gup";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    mainProgram = "gup";
  };
}
