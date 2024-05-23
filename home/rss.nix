{...}: {
  programs.newsboat = {
    enable = true;
    urls = [
      {url = "https://festivus.dev/index.xml";}
      {url = "https://blog.kowalczyk.info/atom.xml";}
      {url = "http://nil.wallyjones.com/feeds/all.atom.xml";}
      {url = "http://habitatchronicles.com/feed/";}
      {url = "http://waywardmonkeys.org/feeds/all.atom.xml";}
      {url = "https://lwn.net/headlines/rss";}
      {url = "https://this-week-in-rust.org/rss.xml";}
      {url = "https://python.libhunt.com/newsletter/feed";}
      {url = "https://blog.adafruit.com/feed/";}
      {url = "https://sparkfun.com/feeds/news";}
      {url = "https://dwheeler.com/blog/index.rss";}
      {url = "https://codewithoutrules.com/atom.xml";}
      {url = "https://gog-games.com/rss";}
      {url = "https://perens.com/feed/";}
      {url = "https://www.trickster.dev/post/index.xml";}
      {url = "https://rsapkf.org/weblog/rss.xml";}
      {url = "https://bollu.github.io/feed.rss";}
      {url = "https://andrewkelley.me/rss.xml";}
      {url = "https://bbengfort.github.io/index.xml";}
      {url = "https://mitchellh.com/feed.xml";}
      {url = "https://eli.thegreenplace.net/feeds/go.atom.xml";}
      {url = "https://threedots.tech/index.xml";}
    ];
  };
}
