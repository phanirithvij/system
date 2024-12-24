{ pkgs, ... }:
{
  # nano like text editor, best tool for non-coding, not an ide
  programs.micro = {
    enable = true;
    settings = {
      colorscheme = "twilight";
      relativeruler = true;
      saveundo = true;
      tabsize = 2;
      tabstospaces = true;
      wordwrap = true;
    };
  };

  # https://github.com/KubqoA/dotfiles/blob/ae3df4e00edb842da44716090cb448c156236932/modules/common/neovim/default.nix#L29
  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraLuaConfig = builtins.readFile ./nvim-init.lua;
    plugins =
      let
        auto-dark-mode-nvim = pkgs.vimUtils.buildVimPlugin {
          name = "auto-dark-mode.nvim";
          src = pkgs.fetchFromGitHub {
            owner = "f-person";
            repo = "auto-dark-mode.nvim";
            rev = "14cad96b80a07e9e92a0dcbe235092ed14113fb2";
            hash = "sha256-bSkS2IDkRMQCjaePFYtq39Bokgd1Bwoxgu2ceP7Bh5s=";
          };
        };
      in
      with pkgs.vimPlugins;
      [
        auto-dark-mode-nvim
        # https://github.com/nvim-treesitter/nvim-treesitter/pull/4658
        (nvim-treesitter.withPlugins (
          plugins: with plugins; [
            tree-sitter-bash
            tree-sitter-json
            tree-sitter-markdown
            tree-sitter-nix
            tree-sitter-python
            tree-sitter-yaml
            tree-sitter-nim
          ]
        ))
        nvim-lspconfig
      ];
  };
}
