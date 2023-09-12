{ pkgs, unstable, ... }: {
  nixpkgs.config.allowUnfree = true;
  home = {
    username = "jeslinmx";
    homeDirectory = "/home/jeslinmx";
    stateVersion = "23.05";
  };
  home.packages = with pkgs; [
    home-manager
    git
    neovim
    vivaldi
    kitty
    starship
    unstable.chezmoi
  ];
  # programs.starship.enable = true;
  # programs.kitty.enable = true;
}
