_: p: {
  git-bug = p.git-bug.override {
    buildGoModule =
      args:
      p.buildGoModule (
        args
        // rec {
          pname = "git-bug";
          version = "master";
          src = p.fetchFromGitHub {
            owner = "git-bug";
            repo = "git-bug";
            rev = "master";
            sha256 = "sha256-SZp0nP8ZJCYU9aPHC0zkqrXYYKS+tP8KvnUfkgqg1HQ=";
          };
          vendorHash = "sha256-POVRVZlS8bld8IMdwuA08nPjXgD0gwVZkF2uw02KKH0=";
          ldflags = [
            "-s"
            "-X github.com/MichaelMure/git-bug/commands.GitCommit=${version}"
            "-X github.com/MichaelMure/git-bug/commands.GitLastTag=${version}"
            "-X github.com/MichaelMure/git-bug/commands.GitExactTag=${version}"
          ];
        }
      );
  };
}
