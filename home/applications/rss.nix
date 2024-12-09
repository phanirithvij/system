{ pkgs, ... }:
{
  programs.newsboat = {
    enable = true;
    urls = map (x: { url = x; }) (
      (map (p: p.meta.homepage + "/releases.atom") (
        with pkgs;
        [
          opengist
          viddy
          gitcs
          gogup
          gomtree
          gh-i
          distrobox-tui
          gama-tui
          gocovsh
          golds
          pkgsite
          tcount
        ]
      ))
      ++ [
        "https://github.com/cloudcannon/pagefind/releases.atom" # homepage is not source url
        "https://invent.kde.org/multimedia/subtitlecomposer/-/tags?format=atom"

        "https://andrewkelley.me/rss.xml"
        "https://ayats.org/feed.xml"
        "https://bbengfort.github.io/index.xml"
        "https://blog.adafruit.com/feed/"
        "https://blog.janissary.xyz/feed.xml"
        "https://blog.kowalczyk.info/atom.xml"
        "https://blog.tiserbox.com/atom.xml"
        "https://bmcgee.ie/posts/index.xml"
        "https://codewithoutrules.com/atom.xml"
        "https://dwheeler.com/blog/index.rss"
        "https://eli.thegreenplace.net/feeds/go.atom.xml"
        "https://exploring-better-ways.bellroy.com/rss.xml"
        "https://fbrs.io/atom.xml"
        "https://festivus.dev/index.xml"
        "https://fmhy.net/feed.rss"
        "https://gog-games.to/rss"
        "http://habitatchronicles.com/feed/"
        "https://lwn.net/headlines/rss"
        "https://mitchellh.com/feed.xml"
        "http://nil.wallyjones.com/feeds/all.atom.xml"
        "https://perens.com/feed/"
        "https://pixel-druid.com/feed.rss"
        "https://python.libhunt.com/newsletter/feed"
        "https://rootknecht.net/index.xml"
        "https://rsapkf.org/weblog/rss.xml"
        "https://sparkfun.com/feeds/news"
        "https://terminaltrove.com/totw.xml"
        "https://terminaltrove.com/new.xml"
        "https://terminaltrove.com/blog.xml"
        "https://this-week-in-rust.org/rss.xml"
        "https://threedots.tech/index.xml"
        "http://waywardmonkeys.org/feeds/all.atom.xml"
        "https://www.trickster.dev/post/index.xml"
        "https://ziglang.org/news/index.xml"
      ]
    );
  };
}
