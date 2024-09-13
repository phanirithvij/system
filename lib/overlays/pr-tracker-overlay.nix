_: p: {
  pr-tracker = p.pr-tracker.overrideAttrs (_: {
    patches = [ ./pr-tracker-gh-token.patch ];
  });
}
