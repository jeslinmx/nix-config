{...}: {
  osConfig,
  pkgs,
  ...
}: {
  home.packages = [pkgs.termshark];
  xdg.configFile."termshark/termshark.toml".source = pkgs.writers.writeTOML "" {
    main = {
      browse-command = ["xdg-open" "$1"];
      dumpcap = osConfig.security.wrapperDir + "/dumpcap";
      theme-256 = "base16";
      theme-truecolor = "base16";
    };
  };
}
