{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gtrash";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "umlx5h";
    repo = "gtrash";
    rev = "v${version}";
    hash = "sha256-odvj0YY18aishVWz5jWcLDvkYJLQ97ZSGpumxvxui4Y=";
  };

  vendorHash = "sha256-JJA9kxNCtvfs51TzO7hEaS4UngBOEJuIIRIfHKSUMls=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.commit=${src.rev}"
    "-X=main.date=1970-01-01T00:00:00Z"
    "-X=main.builtBy=goreleaser"
  ];

  # needs to run inside docker
  doCheck = false;

  meta = {
    description = "A Featureful Trash CLI manager: alternative to rm and trash-cli";
    homepage = "https://github.com/umlx5h/gtrash";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ phanirithvij ];
    mainProgram = "gtrash";
  };
}
