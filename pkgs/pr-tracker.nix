# https://github.com/NixOS/nixpkgs/pull/330824/files
# TODO remove once landed
{
  rustPlatform,
  lib,
  fetchzip,
  openssl,
  pkg-config,
  systemd,
}:

rustPlatform.buildRustPackage rec {
  pname = "pr-tracker";
  version = "1.5.0";

  src = fetchzip {
    url = "https://git.qyliss.net/pr-tracker/snapshot/pr-tracker-${version}.tar.xz";
    hash = "sha256-ENgly8qmE3Xb6XhfjCdxcR0kQF5OTF9ACuCTnWvb+TQ=";
  };

  patches = [ ./matt2432-pr-tracker-c9d0fd535b9ad1b53c212a87e0710d55d8b7f42e.patch ];

  cargoHash = "sha256-F1OwPk8XL0Hyqe9latYrmJhXUIwK9xg/6pi4s1X/vXk=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    systemd
  ];

  meta = with lib; {
    changelog = "https://git.qyliss.net/pr-tracker/plain/NEWS?h=${version}";
    description = "Nixpkgs pull request channel tracker";
    longDescription = ''
      A web server that displays the path a Nixpkgs pull request will take
      through the various release channels.
    '';
    platforms = platforms.linux;
    homepage = "https://git.qyliss.net/pr-tracker";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [
      qyliss
      sumnerevans
    ];
    mainProgram = "pr-tracker";
  };
}
