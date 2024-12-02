{ pkgs, ... }:
{
  programs.lazygit = {
    enable = true;
    settings = {
      disableStartupPopups = true;
      git = {
        commit = {
          signOff = true;
        };
        paging = {
          colorArg = "always";
          pager = "${pkgs.delta}/bin/delta --dark --paging=never";
        };
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
