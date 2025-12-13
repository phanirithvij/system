{
  lib,
  pkgs,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    #nix-output-monitor #need an unstable version, moved to nur
    nvd
    #nh #needs newer nom, moved to nur
  ];

  # TODO lots of duplicate config as host, maybe there can be a common.nix
  sops.secrets."attic/priv_key" = { };
  sops.secrets.github_pat = { };
  sops.templates.nix_netrc = {
    # oranc needs this, maybe can be made conditional mkIf oranc
    content = ''
      machine localhost
          login phanirithvij
          password ${config.sops.placeholder."github_pat"}
      machine iron
          password ${config.sops.placeholder."attic/priv_key"}
    '';
    # gha token can't be accessible for everyone in users only me
  };
  sops.templates.nix_access_tokens = {
    mode = "0400";
    # discourse.nixos.org/t/flakes-provide-github-api-token-for-rate-limiting/18609/2
    content = "access-tokens = github.com=${config.sops.placeholder."github_pat"}";
  };

  nix.package = lib.mkForce pkgs.nixVersions.git; # keep in sync with host to avoid multiple nix versions
  nix.extraOptions = ''
    netrc-file = ${config.sops.templates.nix_netrc.path}
    !include ${config.sops.templates.nix_access_tokens.path}
  '';
}
