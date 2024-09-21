_: {
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
          #pager = "${pkgs.delta}/bin/delta --dark --paging=never";
        };
        autoFetch = false;
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
