{ pkgs, ... }:

{
  services.ssh-agent.enable = true;

  systemd.user.services.ssh-add = {
    Unit = {
      Description = "Add SSH key to ssh-agent";
      After = [ "ssh-agent.service" ];
      Requires = [ "ssh-agent.service" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.openssh}/bin/ssh-add %h/.ssh/id_ed25519";
      Environment = "SSH_AUTH_SOCK=%t/ssh-agent";
      RemainAfterExit = true;
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
