{
  pkgs,
  ...
}:

# Rationale: nix eval runs in a remote system

let
  script = pkgs.writeShellApplication {
    name = "hm-remote";

    runtimeInputs = with pkgs; [
      openssh
      rsync
      nix
      nix-output-monitor
    ];

    text = ''
      BUILDER_HOST="''${BUILDER_HOST:-"admin@192.168.29.77"}"
      FLAKE_DIR="''${FLAKE_DIR:-"$SYSTEM_DIR"}"
      CONFIG_NAME="''${CONFIG_NAME:-"rithvij"}"

      echo "Syncing source to remote builder"
      REMOTE_TMP=$(ssh "$BUILDER_HOST" "mktemp -d -t flake-build-XXXXXX")

      rsync --progress --stats -a --delete --exclude="result*" --exclude=".direnv" "$FLAKE_DIR/" "$BUILDER_HOST:$REMOTE_TMP/"

      echo "Evaluating and building on remote host"
      # shellcheck disable=SC2029
      if ! ssh -t "$BUILDER_HOST" "cd $REMOTE_TMP && nh home build -c $CONFIG_NAME . -o result"; then
              echo "Build failed on remote builder."
              exit 1
      fi

      # shellcheck disable=SC2029
      HM_RESULT=$(ssh "$BUILDER_HOST" "readlink -f $REMOTE_TMP/result")

      echo "Copying closure back to local machine ($HM_RESULT)"
      nix copy --from "ssh-ng://$BUILDER_HOST" --no-check-sigs "$HM_RESULT" --log-format internal-json 2>&1 | nom --json

      echo "Please run ./result/hm-rithvij/specialisation/xfce/bin/activate"
      mkdir -p ./result
      ln -sf "$HM_RESULT" ./result/hm-rithvij
    '';
  };
in
{
  home.packages = [ script ];
}
