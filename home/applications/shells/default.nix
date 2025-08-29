{
  pkgs,
  lib,
  hostname,
  system,
  ...
}:
let
  hostvars = import ../../../hosts/${hostname}/variables.nix;
in
{
  imports = [
    ./bash.nix
    ./fish.nix
    ./lf.nix
  ];

  home.packages = lib.optional (system == "x86_64-linux") pkgs.boxxy;

  programs.global-aliases.enable = true;
  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      style = "compact";
      inline_height = 24;
      invert = false;
    };
  };
  programs.bat.enable = true;

  programs.eza.enable = true;
  programs.eza-aliases.enable = true;

  programs.duf-aliases.enable = true;

  programs.fd = {
    enable = true;
    package = pkgs.fd;
  };
  # https://github.com/junegunn/fzf/issues/3914
  programs.fzf = {
    enable = true;
    defaultCommand = "${pkgs.fd}/bin/fd --type f --strip-cwd-prefix --hidden --follow --exclude .git";
    fileWidgetCommand = "${pkgs.fd}/bin/fd --type f --strip-cwd-prefix --hidden --follow --exclude .git";
    tmux.enableShellIntegration = true; # for sesh
  };
  programs.starship = {
    enable = true;
    package = pkgs.nurPkgs.starship;
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
      # https://starship.rs/config/#hide-the-hostname-in-remote-tmux-sessions
      hostname = {
        ssh_only = false;
        detect_env_vars = [
          "!TMUX"
          "SSH_CONNECTION"
        ];
        disabled = false;
      };
      # https://starship.rs/config/#username
      # disable showing username in remote sessions
      #username.detect_env_vars = [ "!SSH_CONNECTION" ]; #not working
      # patched starship instead, in nurpkgs
    };
  };
  # https://github.com/nix-community/home-manager/issues/6455
  programs = {
    zoxide = {
      enable = true;
      enableBashIntegration = false;
    };
    bash.initExtra =
      lib.mkOrder 2000 # sh
        ''
          eval "$(${lib.getExe pkgs.zoxide} init bash)"    
        '';
  };

  home.sessionVariables = {
    inherit (hostvars) SYSTEM_DIR OWN_DIR;
  }
  // lib.mkIf (hostvars ? DBX_CONTAINER_MANAGER) { inherit (hostvars) DBX_CONTAINER_MANAGER; };
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/go/bin"
  ];
}
