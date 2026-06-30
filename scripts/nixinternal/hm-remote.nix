{
  pkgs,
  ...
}:

# Rationale: to make nix eval run in a remote system

pkgs.writeShellApplication {
  name = "hm-remote";

  runtimeInputs = with pkgs; [
    openssh
    rsync
    nix
    nix-output-monitor
  ];

  text = ''
    BUILDER_HOST="''${BUILDER_HOST:-"admin@nixus"}"
    FLAKE_DIR="''${FLAKE_DIR:-"$SYSTEM_DIR"}"

    HM_CONFIG_NAME="''${HM_CONFIG_NAME:-"rithvij"}"
    OS_CONFIG_NAME="''${OS_CONFIG_NAME:-"iron"}"

    HM_NH_ARGS="''${HM_NH_ARGS:-"home build -c $HM_CONFIG_NAME"}"
    OS_NH_ARGS="''${OS_NH_ARGS:-"os build -H $OS_CONFIG_NAME"}"

    HM_OUT_LINK="''${HM_OUT_LINK:-"hm-$HM_CONFIG_NAME"}"
    OS_OUT_LINK="''${OS_OUT_LINK:-"h-$OS_CONFIG_NAME"}"

    echo "Syncing source to remote builder"
    REMOTE_TMP=$(ssh "$BUILDER_HOST" "mktemp -d -t flake-build-XXXXXX")

    rsync --progress --stats -a --delete --exclude="result*" --exclude=".direnv" "$FLAKE_DIR/" "$BUILDER_HOST:$REMOTE_TMP/"

    echo "Evaluating and building hm on remote host"
    # shellcheck disable=SC2029
    if ! ssh -t "$BUILDER_HOST" "cd $REMOTE_TMP && nh $HM_NH_ARGS . -o result"; then
            echo "Home-Manager build failed on remote builder."
            exit 1
    fi

    # shellcheck disable=SC2029
    OUT_RESULT=$(ssh "$BUILDER_HOST" "readlink -f $REMOTE_TMP/result")

    echo "Copying closure back to local machine ($OUT_RESULT)"
    nix copy --from "ssh-ng://$BUILDER_HOST" --no-check-sigs "$OUT_RESULT" --log-format internal-json 2>&1 | nom --json

    echo "Please run ./result/$HM_OUT_LINK/specialisation/xfce/activate"
    mkdir -p ./result
    ln -sf "$OUT_RESULT" "./result/$HM_OUT_LINK"

    echo "Evaluating and building os on remote host"
    # shellcheck disable=SC2029
    if ! ssh -t "$BUILDER_HOST" "cd $REMOTE_TMP && nh $OS_NH_ARGS . -o result"; then
            echo "NixOS build failed on remote builder."
            exit 1
    fi

    # shellcheck disable=SC2029
    OUT_RESULT=$(ssh "$BUILDER_HOST" "readlink -f $REMOTE_TMP/result")

    echo "Copying closure back to local machine ($OUT_RESULT)"
    nix copy --from "ssh-ng://$BUILDER_HOST" --no-check-sigs "$OUT_RESULT" --log-format internal-json 2>&1 | nom --json

    echo "Please run sudo env NIXOS_INSTALL_BOOTLOADER=1 ./result/$OS_OUT_LINK/bin/switch-to-configuration boot"
    mkdir -p ./result
    ln -sf "$OUT_RESULT" "./result/$OS_OUT_LINK"
  '';
}
