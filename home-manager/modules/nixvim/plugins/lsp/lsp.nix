{ flake, ... }: {
  programs.nixvim.plugins = {
      lsp = {
        enable = true;
        servers = {
          nixd = {
            enable = true;
            extraOptions = {
              nixpkgs.expr = "import <nixpkgs> {}";
              formatting.command = [ "alejandra" ];
              options = {
                nixos.expr = "(builtins.getFlake ${flake}).nixosConfigurations.jeshua-xps-9510.options";
              };
            };
          };
        };
      };
      conform-nvim = {}; # formatter
      coq-nvim = {}; # autocompletion
      dap = {}; # debug adapter protocol
      lint = {};
      schemastore = {};
  };
}
