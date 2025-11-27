{ pkgs, flake-inputs, ... }:
{
  imports = [
    "${flake-inputs.reaction-module}/modules/common/reaction.nix"
    #"${flake-inputs.reaction-module}/modules/common/reaction-custom.nix"
    #"${flake-inputs.reaction-module}/modules/common/monit.nix"
  ];
  config =
    let
      sudoRule = {
        users = [ "reaction" ];
        commands = [
          {
            command = "${pkgs.iptables}/bin/iptables";
            options = [ "NOPASSWD" ];
          }
          {
            command = "${pkgs.iptables}/bin/ip6tables";
            options = [ "NOPASSWD" ];
          }
        ];
        runAs = "root";
      };
    in
    {
      services.reaction = {
        enable = true;
        settingsFiles = [ ./example.jsonnet ];
        #runAsRoot = true;
        #enableGoogleImpersonator = true;
        #enableGPTBot = true;
      };
      #ppom.monit.fromMail = "musi@ppom.me";

      # TODO why isn't this in the config? and runAsRoot is not the same?
      users.users.reaction.extraGroups = [ "systemd-journal" ]; # "wheel" ];

      security.sudo.extraRules = [ sudoRule ];
      security.sudo-rs.extraRules = [ sudoRule ];
    };
}
