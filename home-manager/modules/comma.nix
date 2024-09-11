{ flake, ... }: {
  imports = [flake.inputs.nix-index-database.hmModules.nix-index];
  programs = {
    nix-index.enable = true;
    nix-index-database.comma.enable = true;
  };
}
