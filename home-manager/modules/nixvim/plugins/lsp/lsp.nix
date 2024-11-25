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
          jsonls.enable = true;
          yamlls.enable = true;
        };
      };
      schemastore = {
        enable = true;
        json = {
          enable = true;
          settings.extra = [
            {
              description = "Fastfetch config file schema";
              fileMatch = "config.jsonc";
              name = "fastfetch";
              url = "https://raw.githubusercontent.com/fastfetch-cli/fastfetch/refs/heads/dev/doc/json_schema.json";
            }
          ];
        };
        yaml.enable = true;
      };
      conform-nvim = {}; # formatter
      coq-nvim = {
        # autocompletion
        enable = true;
        installArtifacts = true;
        settings.auto_start = true;
      };
      dap = {}; # debug adapter protocol
      lint = {};
      schemastore = {};
  };
}
