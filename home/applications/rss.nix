{ pkgs, ... }:
{
  /*
    many rss tools
    rsshub
    https://github.com/RSS-Bridge/rss-bridge
    freshrss
    feedpushr
    ntfy/gotify
    https://github.com/QuiteRSS/quiterss
    https://github.com/miniflux/v2
    https://github.com/derek-zhou/airss
    https://news.ycombinator.com/item?id=33469271
    https://github.com/leafac/kill-the-newsletter
    https://github.com/rss2email/rss2email
    https://feed-me-up-scotty.vincenttunru.com/
    feedbin
    https://github.com/georgemandis/bubo-rss
    openring https://news.ycombinator.com/item?id=33475112
    https://statmodeling.stat.columbia.edu/blogs-i-read/
      - example good UI layout for blogs-i-read idea
    webring
    buku, archivebox (not rss but hmm?)
  */
  programs.newsboat = {
    enable = true;
    urls = map (x: { url = x; }) (
      (map (p: p.meta.homepage + "/releases.atom") (
        with pkgs;
        [
          # https://discourse.nixos.org/t/eval-nix-expression-from-the-command-line/8993/8?u=phanirithvij
          # nix-instantiate --eval -E 'import ./scripts/nixinternal/nixpkgs-pkgs-maintained-by-user.nix { }' | jq -r
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
          pfetch
        ]
      ))
      ++ [
        # nixpkgs software releases
        "https://github.com/cloudcannon/pagefind/releases.atom" # homepage is not source url
        "https://invent.kde.org/multimedia/subtitlecomposer/-/tags?format=atom"

        # TODO group into categories!

        # nix, nixos
        "https://ayats.org/feed.xml"
        "https://bmcgee.ie/posts/index.xml"
        "https://blog.janissary.xyz/feed.xml"
        "https://nixos.mayflower.consulting/blog/index.xml"
        "https://exploring-better-ways.bellroy.com/rss.xml"
        "https://fbrs.io/atom.xml"
        "https://fzakaria.com/feed.xml"
        "https://ghedam.at/feed.xml"
        "https://myme.no/atom-feed.xml"
        "https://www.thedroneely.com/posts/rss.xml"

        # go
        "https://bbengfort.github.io/index.xml"
        "https://codewithoutrules.com/atom.xml"
        "https://threedots.tech/index.xml"
        "https://bitfieldconsulting.com/posts?format=rss"

        # (python)
        "https://python.libhunt.com/newsletter/feed"
        "https://www.trickster.dev/post/index.xml"

        # rust
        "http://waywardmonkeys.org/feeds/all.atom.xml"
        "https://this-week-in-rust.org/rss.xml"
        "https://blog.orhun.dev/rss.xml"

        # zig
        "https://andrewkelley.me/rss.xml"
        "https://ziglang.org/news/index.xml"
        "https://mitchellh.com/feed.xml"
        "https://buttondown.email/ZigSHOWTIME/rss"

        # hardware
        "https://blog.adafruit.com/feed/"

        # windows
        "https://blog.kowalczyk.info/atom.xml"
        "https://blog.tiserbox.com/atom.xml"
        "https://dwheeler.com/blog/index.rss"
        "https://eli.thegreenplace.net/feeds/go.atom.xml"
        "https://festivus.dev/index.xml"

        # entertainment
        "https://fmhy.net/feed.rss"
        "https://gog-games.to/rss"

        # tech news, programming lang changelogs
        "https://lwn.net/headlines/rss"

        # general tech
        "http://habitatchronicles.com/feed/"
        "https://til.hashrocket.com/rss"
        "https://unplannedobsolescence.com/atom.xml"

        # discover new projects
        "https://terminaltrove.com/totw.xml"
        "https://terminaltrove.com/new.xml"
        "https://terminaltrove.com/blog.xml"
        # TODO changelog nightly rss feed via kill-the-newsletter or rss-bridge or something
        # they provide web readable urls

        # blog of thoughts (people)
        "https://pixel-druid.com/feed.rss"
        "https://rsapkf.org/weblog/rss.xml"
        "https://kevincox.ca/feed.atom"

        # linux
        "https://www.nico.schottelius.org/blog-archive/index.rss"

        # unorganized
        "http://nil.wallyjones.com/feeds/all.atom.xml"
        "https://perens.com/feed/"
        "https://rootknecht.net/index.xml"
        "https://sparkfun.com/feeds/news"
      ]
    );
  };
}
