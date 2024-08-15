{
  prSections = [
    {
      title = "My Pull Requests";
      filters = "is:open author:@me";
      layout = {
        author = {
          hidden = true;
        };
      };
    }
    {
      title = "Needs My Review";
      filters = "is:open review-requested:@me";
    }
    {
      title = "Subscribed";
      filters = "is:open -author:@me repo:cli/cli repo:dlvhdr/gh-dash";
      limit = 50;
    }
    {
      title = "Involved";
      filters = "is:open involves:@me -author:@me";
    }
  ];
  issuesSections = [
    {
      title = "Created";
      filters = "is:open author:@me";
    }
    {
      title = "Assigned";
      filters = "is:open assignee:@me";
    }
    {
      title = "Subscribed";
      filters = "is:open -author:@me repo:microsoft/vscode repo:dlvhdr/gh-dash";
    }
  ];
  defaults = {
    layout = {
      prs = {
        repo = {
          grow = true;
          width = 10;
          hidden = false;
        };
      };
    };
    prsLimit = 20; # TODO no limits
    issuesLimit = 20;
    preview = {
      open = true;
      width = 60;
    };
    refetchIntervalMinutes = 10;
  };
  repoPaths = {
    #"dlvhdr/*" = "~/code/repos/dlvhdr/*";
    "phanirithvij/system" = "~/system";
    "golang/go" = "/tmp/fk/go";
  };
  keybindings = null;
  #pager = {
  #  diff = "delta";
  #};
  confirmQuit = false;
}
