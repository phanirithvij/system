{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gocovsh";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "orlangure";
    repo = "gocovsh";
    rev = "v${version}";
    hash = "sha256-VZNu1uecFVVDgF4xDLTgkCahUWbM+1XASV02PEUfmr0=";
  };

  vendorHash = "sha256-Fb7BIWojOSUIlBdjIt57CSvF1a+x33sB45Z0a86JMUg=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Go Coverage in your terminal: a tool for exploring Go Coverage reports from the command line";
    homepage = "https://github.com/orlangure/gocovsh";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "gocovsh";
  };
}
