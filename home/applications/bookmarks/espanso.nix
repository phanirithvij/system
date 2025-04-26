{
  pkgs,
  wifipassFile,
  ...
}:
let
  inherit (pkgs) lib xdotool;
in
{
  services.espanso = {
    enable = true;
    x11Support = lib.mkDefault true;
    waylandSupport = lib.mkDefault true;
    # TODO config, matches
    # gh auth token | xclip -sel clipboard
    # https://github.com/phanirithvij
    # https://github.com/phanirithvij/system
    # @phanirithvij, :me
    # private matches
    # TODO other crazy things
    # navi matches module
    # passwords matches
    # authpass module
    # lesspass module
    # gopass module
    # buku module
    # generate yaml no need for nix-fu
    # replaceVars maybe and in wrappedPkgs
    matches = {
      base = {
        matches = [
          {
            trigger = ":nixs";
            replace = "nix-shell";
          }
          {
            trigger = ":date";
            label = "indian";
            replace = "{{mydate}}";
            vars = [
              {
                name = "mydate";
                type = "date";
                params = {
                  format = "%m/%d/%Y";
                };
              }
            ];
          }
          {
            trigger = ":date";
            replace = "{{mydate}}";
            label = "lexico";
            vars = [
              {
                name = "mydate";
                type = "date";
                params = {
                  format = "%Y-%m-%d";
                };
              }
            ];
          }
          {
            triggers = [
              ":date"
              ":now"
            ];
            replace = "{{mydate}}";
            label = "2024-12-21T21:14";
            vars = [
              {
                name = "mydate";
                type = "date";
                params = {
                  # 2024-12-21T21:13
                  format = "%FT%H:%M";
                };
              }
            ];
          }
          {
            triggers = [
              ":date"
              ":now"
            ];
            replace = "{{mydate}}";
            label = "2024-12-21T21:14:18.216131770+05:30";
            vars = [
              {
                name = "mydate";
                type = "date";
                params = {
                  # 2024-12-21T21:13:52.978767200+05:30
                  # https://discord.com/channels/884163483409731584/1013916990760554608/1320014927695577169 (Espanso discord)
                  format = "%+";
                };
              }
            ];
          }
          # https://pastebin.com/8wy9dAU3
          # https://discord.com/channels/884163483409731584/1013914627886817372/1252015636876492882 (Espanso discord)
          {
            regex = "(?P<offset>[+-]\\d+)(?P<unit>[dwmy])";
            label = "Bash offset date";
            replace = "{{output}}";
            vars = [
              {
                name = "output";
                type = "shell";
                params = {
                  shell = "bash";
                  cmd = # bash
                    ''
                      case {{unit}} in
                        d) date=$(date -d "{{offset}} days" +"%Y-%m-%d") ;;
                        w) date=$(date -d "({{offset}} * 7) days" +"%Y/%m/%d") ;;
                        m) date=$(date -d "{{offset}} months" +"%Y/%m/%d") ;;
                        y) date=$(date -d "{{offset}} years" +"%Y/%m/%d") ;;
                      esac
                      echo "$date"
                    '';
                };
              }
            ];
          }
          {
            trigger = ":wifi";
            replace = "{{finalpass}}";
            # ORDER matters
            vars = [
              {
                name = "pwlist";
                type = "shell";
                params = {
                  cmd = "cat ${wifipassFile} | cut -d'=' -f1";
                };
              }
              {
                name = "form2";
                type = "form";
                params = {
                  layout = "wifi [[passwd]]";
                  fields = {
                    passwd = {
                      type = "list";
                      values = "{{pwlist}}";
                    };
                  };
                };
              }
              {
                name = "finalpass";
                type = "shell";
                params = {
                  cmd = "cat ${wifipassFile} | grep {{form2.passwd}} | cut -d'=' -f2-";
                };
              }
            ];
          }
          {
            trigger = ":prefetch";
            replace = "{{prefetch}}";
            vars = [
              {
                name = "form1";
                type = "form";
                params = {
                  layout = "sha256 for [[url]]";
                };
              }
              {
                name = "prefetch";
                type = "shell";
                params = {
                  cmd = "nix-prefetch-patch '{{form1.url}}'";
                };
              }
            ];
          }
          {
            trigger = ":5months";
            replace = ''
              https://github.com/avelino/awesome-go/blob/main/CONTRIBUTING.md#quality-standards
              > have at least 5 months of history since the first commit.
            '';
          }
          # https://github.com/espanso/espanso/discussions/1885#discussioncomment-8682979
          # https://discord.com/channels/884163483409731584/1013914627886817372/1235217704986738709
          # TODO: nix-prefetch-patch above with selected text maybe
          {
            trigger = "";
            label = "Modify selected text CTRL+_";
            replace = "{{output}}";
            vars = [
              {
                name = null;
                type = "shell";
                params = {
                  shell = "bash";
                  cmd = "${lib.getExe xdotool} key --clearmodifiers ctrl+c";
                };
              }
              {
                name = "clipb";
                type = "clipboard";
              }
              {
                name = "script_choice";
                type = "choice";
                params = {
                  values = [
                    {
                      label = "Uppercase";
                      id = "upper";
                    }
                    {
                      label = "Lowercase";
                      id = "lower";
                    }
                    {
                      label = "Initcase";
                      id = "initcap";
                    }
                    {
                      label = "Evaluate equation";
                      id = "math";
                    }
                    {
                      label = "Word count";
                      id = "wordcount";
                    }
                  ];
                };
              }
              {
                name = "output";
                type = "shell";
                params = {
                  shell = "bash";
                  cmd = # bash
                    ''
                      case "{{script_choice}}" in
                        upper)
                          echo "{{clipb}}" | tr '[:lower:]' '[:upper:]';;
                        lower)
                          echo "{{clipb}}" | tr '[:upper:]' '[:lower:]';;
                        initcap)
                          awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1' <<< "{{clipb}}";;
                        wordcount)
                          echo "{{clipb}}" ; echo "{{clipb}}" | wc -w;;
                        math)
                          awk "BEGIN {print {{clipb}}}";;
                      esac
                    '';
                };
              }
            ];
          }
        ];
      };
    };
  };
}
