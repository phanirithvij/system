_: {
  programs.newsboat = {
    enable = true;
    urls = builtins.map (x: { url = x; }) [
      "https://invent.kde.org/multimedia/subtitlecomposer/-/tags?format=atom"
      "https://github.com/YS-L/csvlens/releases.atom"
      "https://andrewkelley.me/rss.xml"
      "https://bbengfort.github.io/index.xml"
      "https://blog.adafruit.com/feed/"
      "https://blog.janissary.xyz/feed.xml"
      "https://blog.kowalczyk.info/atom.xml"
      "https://bmcgee.ie/posts/index.xml"
      "https://codewithoutrules.com/atom.xml"
      "https://dwheeler.com/blog/index.rss"
      "https://eli.thegreenplace.net/feeds/go.atom.xml"
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
    ];
  };
}
