{ pkgs, ... }: {
  home.file.".ssh/authorized_keys".source = (pkgs.fetchurl {
    url = "https://github.com/jeslinmx.keys";
    hash = "sha256-BwgEaDlwJqFyu0CMhKbGK6FTMYfgZCWnS8Arhny66Pg=";
  }).outPath;
}
