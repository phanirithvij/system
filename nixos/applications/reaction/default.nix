_: {
  services.reaction = {
    enable = true;
    settingsFiles = [ ./example.jsonnet ];
    runAsRoot = true;
    stopForFirewall = true;
  };
}
