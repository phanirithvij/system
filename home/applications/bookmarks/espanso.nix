{
  wifipassFile,
  ...
}:
{
  services.espanso = {
    enable = true;
    x11Support = true;
    waylandSupport = true;
    # TODO config, matches
    # gh auth token | xclip -sel clipboard
    # https://github.com/phanirithvij
    # https://github.com/phanirithvij/system
    # @phanirithvij
    # private matches
    # TODO other crazy things
    # navi matches module
    # passwords matches
    # authpass module
    # lesspass module
    # gopass module
    # buku module
    matches = {
      base = {
        matches = [
          {
            trigger = ":nixs";
            replace = "nix-shell";
          }
          {
            trigger = ":date";
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
            trigger = ":wifipass";
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
                  cmd = "nix hash convert --hash-algo sha256 --from nix32 $(nix-prefetch-url --name legal '{{form1.url}}')";
                };
              }
            ];
          }
        ];
      };
    };
  };
}
