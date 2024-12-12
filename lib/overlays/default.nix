_:
let
  tempLazygitOverlay = _: p: {
    lazygit = p.lazygit.overrideAttrs (_: {
      patches = [
        (p.fetchpatch2 {
          url = "https://github.com/jesseduffield/lazygit/pull/4097.diff";
          hash = "sha256-DVY+E/RKc+j0UGlHf5QwCmQ5O5JYxbZEiOnh9N5UmqI=";
        })
      ];
    });
  };
in
[
  tempLazygitOverlay
]
