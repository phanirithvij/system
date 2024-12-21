{ pkgs, ... }:
{
  services.mediawiki = {
    enable = true;
    database.type = "postgres";
    name = "nixos wiki selfhosted";
    webserver = "nginx";
    # TODO sops
    passwordFile = pkgs.writeText "mediawiki-passwd-file" "mediawikipassed";
    # createLocally is true, need to set password ourselves, not managed by this module
    # or do createLocally false and sops and own postgres config
    # sudo -u postgres psql -c "ALTER ROLE mediawiki WITH LOGIN PASSWORD 'mediawiki'"
    skins = {
      Tweeki = pkgs.fetchFromGitHub {
        owner = "thaider";
        repo = "Tweeki";
        rev = "bb5fb1276ab17e9715e1ac001ed3cedaafb89e55";
        hash = "sha256-AuaEa0u68NL+08N/y7hr0G7i9MI/SvGbvakFpOdvtJM=";
        #rev = "refs/tags/v1.2.7";
        #hash = "sha256-fWEt/WzzKQOnlwsup+1nvLYVt5OJRUJl7m1BJZT3TZo=";
      };
    };
    extensions = {
      SyntaxHighlight_GeSHi = null; # provides <SyntaxHighlight> tags
      ParserFunctions = null;
      Cite = null;
    };
    extraConfig = ''
      $wgDefaultSkin = "tweeki";
      $wgShowExceptionDetails = true;
      $wgPygmentizePath = "${pkgs.python3Packages.pygments}/bin/pygmentize";
    '';
  };
}
