{ pkgs, ... }:
{
  programs.lazygit = {
    enable = true;
    settings = {
      # TODO EDITOR and VISUAL not working clearly a bug
      # found this hack via https://github.com/jesseduffield/lazygit/issues/514#issuecomment-2616748964
      os.editPreset = "micro";
      disableStartupPopups = true;
      git = {
        overrideGpg = true;
        commit = {
          signOff = true;
        };
        pagers = [
          {
            colorArg = "always";
            pager = "${pkgs.delta}/bin/delta --dark --paging=never";
          }
        ];
        autoFetch = false;
        # deprecated, <c-l> and select default, becomes imperative
        log.order = "default"; # large repos, default is topo-order
      };
      gui = {
        showBottomLine = false;
        showCommandLog = true;
        showIcons = false;
        showListFooter = false;
        showRandomTip = false;
        theme = {
          showFileTree = true;
        };
      };
      notARepository = "quit";
      promptToReturnFromSubprocess = false;
    };
  };
}
