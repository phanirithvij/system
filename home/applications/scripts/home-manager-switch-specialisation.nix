{
  pkgs,
  ...
}:
let
  awk = "${pkgs.gawk}/bin/awk";
  jq = "${pkgs.jq}/bin/jq";
  sh = "${pkgs.bash}/bin/sh";
  nh = "${pkgs.nh}/bin/nh";
  nix = "${pkgs.nix}/bin/nix";

  # I am slightly overcomplicating it
  # /etc/specialisation can be created https://github.com/Frontear/dotfiles/blob/8dac4f4f12c74746a6213a2a67d81428b248ca89/modules/nixos/extended/module.nix#L16
  script =
    pkgs.writeShellScriptBin "hm-host-sp-sync"
      # bash
      ''
        user="$(whoami)"
        # get active home sp
        hm_sp_file="/home/$user/.local/share/home-manager/specialisation"
        hm_sp=""
        if [ -f $hm_sp_file ]; then
          hm_sp="$(head -n 1 $hm_sp_file)"
        fi

        # get active host sp
        host_sp=$(\
          ${jq} '."org.nixos.bootspec.v1".label' \
          -r /run/current-system/boot.json \
          | ${awk} -F: '{printf $2}' \
          | ${awk} -F- '{printf $1}'\
        )

        if [ "$hm_sp" = "$host_sp" ]; then
          # matching specialisations active, early exit
          exit 0
        fi

        if [ -z "$host_specialisation" ]; then
          /run/wrappers/bin/su $user -s ${sh} -c "${nh} home switch $SYSTEM_DIR"
        else
          home_gen=$(\
            ${nix} \
            --extra-experimental-features nix-command \
            --extra-experimental-features flakes \
            --no-link --print-out-paths \
            build "$SYSTEM_DIR#homeConfigurations.$user@$HOSTNAME.activationPackage"\
          )
          if [ -d "$home_gen/specialisation/$host_sp" ]; then
            /run/wrappers/bin/su $user -s ${sh} -c "${nh} home switch -s $host_sp $SYTEMD_DIR"
          else
            echo "home-manager has no matching host specialisation $host_sp, leaving unchanged"
          fi
        fi
      '';
in
{
  /*
    https://search.nixos.org/options?query=activationScripts
    TODO: this should be a user level one-shot systemd service
    a script parameterised to pickup "user", in hm config
    maybe also called in userActivationScripts but primary location should not be here
    reasons:
      - decoupled from system config
      - multi-user user configurable
      - run in background and not slowdown boot time
    also:
      - idempotent
  */
  /*
    # TODO this should be in the system config
    system.userActivationScripts = {
      hm-host-sp-sync.text = lib.getExe script;
    };
  */
  home.packages = [ script ];
}
