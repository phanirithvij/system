{ lazy-app, system, ... }:
lazy-app.override {
  pkg =
    (builtins.getFlake "github:utdemir/nix-tree/d5fe2c2af3aa83577b0dd191ef9de19f27f91b2a")
    .packages.${system}.default;
}
