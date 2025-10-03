{
  lib,
  stdenv,
  fetchFromGitea,
  makeWrapper,
  bash,
  sudo,
  fzf,
  curl,
  wget,
  gzip,
}:

stdenv.mkDerivation rec {
  pname = "pacui";
  version = "0-unstable-2025-09-24";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "excalibur1234";
    repo = "pacui";
    rev = "a57ca4a59db6397a3cf0523990822c475f5aa91e";
    hash = "sha256-YzzhhNEg6pvTs8cT66nfxYmsvXv/k6w1GXwCKzIH1Pk=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ bash ];

  # Dependencies available in nixpkgs
  runtimeDependencies = [
    sudo
    fzf
    curl
    wget
    gzip
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 pacui $out/bin/pacui

    # Wrap the script to ensure nixpkgs dependencies are in PATH
    # Note: expac, pacman-contrib, and other Arch-specific tools
    # are assumed to be available in the system PATH
    wrapProgram $out/bin/pacui \
      --prefix PATH : ${lib.makeBinPath runtimeDependencies}

    runHook postInstall
  '';

  meta = {
    description = "Bash script providing advanced Pacman and AUR helper commands in a user-friendly text interface";
    longDescription = ''
      PacUI provides useful and advanced Pacman and Yay/Pikaur/Aurman/Pakku/Trizen/Paru/Pacaur/Pamac-cli
      commands in a convenient and easy-to-use text interface. It is aimed at experienced users of
      Arch Linux (and Arch-based distributions, including Manjaro).

      The script is contained within one file with easy-to-read bash code with many helpful comments.

      Note: This package only includes dependencies available in nixpkgs. Arch-specific tools like
      pacman, expac, pacman-contrib, and AUR helpers must be available in your system PATH.
    '';
    homepage = "https://codeberg.org/excalibur1234/pacui";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.phanirithvij ];
    mainProgram = "pacui";
  };
}
