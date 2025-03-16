{
  programs.mr.enable = true;
  programs.mr.settings = {
    "/shed/Projects/nur-packages" = {
      checkout = "git clone https://github.com/phanirithvij/nur-packages.git";
    };
  };
}
