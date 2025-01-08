{
  programs.atuin = {
    flags = ["--disable-up-arrow"];
    settings = {
      update_check = false;
      style = "compact";
      inline_height = 9 + 4; # header, current, input, preview
      invert = true;
      show_preview = true;
      enter_accept = false;
      exit_mode = "return-query";
    };
  };
}
