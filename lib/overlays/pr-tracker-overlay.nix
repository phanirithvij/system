_: p: {
  pr-tracker = p.pr-tracker.overrideAttrs (_: {
    patches = [ ./matt2432-pr-tracker-c9d0fd535b9ad1b53c212a87e0710d55d8b7f42e.patch ];
  });
}
