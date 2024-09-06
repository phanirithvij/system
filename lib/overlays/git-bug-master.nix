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
            sha256 = "sha256-VWopJ7FyJyN1PD5mN/1c7VZRcDhPn3rvpM9TS8+7zIw=";
          };
          vendorHash = "sha256-wux4yOc5OV0b7taVvUy/LIDqEgf5NoyfGV6DVOlczPU=";
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
