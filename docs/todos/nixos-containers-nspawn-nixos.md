## what

os level vs flake managed

pros

- isolated flake feels superior, like can run in non-nixos
  - maybe can be made to run as part of nixos-containers too, incorporate into
    system configuration
  - there was a nix profile manager or something which allows decoupling from
    the system config TBA
  - Maybe `nimi` can be made to work with this, https://github.com/weyl-ai/nimi

cons

- more moving targets, and huge system images when sysm could work fine

notes

- prefer nspawn when sysm fails to accomodate
