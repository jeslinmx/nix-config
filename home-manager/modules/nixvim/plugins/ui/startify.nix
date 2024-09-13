{ config, pkgs, ... }: let
  inherit (config.nixvim.helpers) mkRaw;
in {
  programs.nixvim = {
    autoCmd = [
      {
        event = "User";
        pattern = "StartifyReady";
        command = "lua vim.b.miniindentscope_disable = true";
      }
    ];
    keymaps = [
      { key = "<Leader>~"; action = "<Cmd>Startify<CR>"; options.desc = "Open start screen (Startify)"; }
    ];
    plugins.startify = {
      enable = true;
      settings = {
        custom_header = [
          "         oo                   oo            "
          "                                            "
          "88d888b. dP dP.  .dP dP   .dP dP 88d8b.d8b. "
          "88'  `88 88  `8bd8'  88   d8' 88 88'`88'`88 "
          "88    88 88  .d88b.  88 .88'  88 88  88  88 "
          "dP    dP dP dP'  `dP 8888P'   dP dP  dP  dP "
        ];
        custom_footer = [
          (mkRaw "tostring(math.randomseed(os.time()) or '')")
          (mkRaw "vim.fn.system('${pkgs.kjv}/bin/kjv Psalms 119:' .. math.ceil(math.random() * 176)):match('^(.-)%s*$')")
        ];
        change_to_vcs_root = true;
        custom_indices = ["a" "s" "d" "f" "g" "h" "j" "k" "l" ";"];
        relative_path = true;
        session_persistence = true;
        session_sort = true;
        update_oldfiles = true;
        lists = [
          {
            type = "dir";
            header = [
              (mkRaw ''
                table.concat({
                  '   MRU',
                  vim.loop.cwd(),
                  vim.fn.system('${pkgs.git}/bin/git log -1 --format="(%h %s)" -z 2> /dev/null')
                }, ' ')
              '')
            ];
          }
          {
            type = "sessions";
            header = ["    Sessions"];
          }
          {
            type = "bookmarks";
            header = ["    Bookmarks"];
          }
          {
            type = "commands";
            header = ["    Commands"];
          }
        ];
      };
    };
  };
}
