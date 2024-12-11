{ config, pkgs, ... }:
let
  awk = "${pkgs.gawk}/bin/awk";
  jq = "${pkgs.jq}/bin/jq";
  sh = "${pkgs.bash}/bin/sh";
in
{
  system.activationScripts = {
    # I am slightly overcomplicating it
    # /etc/specialisation can be created https://github.com/Frontear/dotfiles/blob/8dac4f4f12c74746a6213a2a67d81428b248ca89/modules/nixos/extended/module.nix#L16
    home-manager-specialisations.text =
      # bash
      ''
        host_specialisation=$(${jq} '."org.nixos.bootspec.v1".label' -r /run/current-system/boot.json | ${awk} -F: '{printf $2}' | ${awk} -F- '{printf $1}')
        user="${config.users.users.rithvij.name}"
        # TODO this is wrong, need to save specialisation and store paths mapping in a file
        # for this to even begin to work
        home_gen="$(/run/wrappers/bin/su $user -s ${sh} -c "home-manager generations | head -1 | awk '{printf \$NF}'")"
        if [ -z "$host_specialisation" ]; then
          /run/wrappers/bin/su $user -s ${sh} -c "$home_gen/activate"
        else
          if [ -d "$home_gen/specialisation/$host_specialisation" ]; then
            /run/wrappers/bin/su $user -s ${sh} -c "$home_gen/specialisation/$host_specialisation/activate"
          else
            echo "home-manager has no matching host specialisation $host_specialisation, leaving unchanged"
          fi
        fi
      '';
  };
}
