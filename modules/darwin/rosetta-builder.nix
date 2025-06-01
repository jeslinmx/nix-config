{inputs, ...}: {
  imports = [inputs.nix-rosetta-builder.darwinModules.default];

  # # for bootstrapping rosetta-builder
  # nix.linux-builder = {
  #   enable = true;
  #   ephemeral = true;
  # };

  nix-rosetta-builder = {
    memory = "12GiB";
    onDemand = true;
    onDemandLingerMinutes = 60;
  };
}
