{ # minimalist notifications and LSP messages
  programs.nixvim = {
    plugins.hydra = {
      enable = true;
      hydras = [
        {
          name = "WINDOW";
          mode = "n";
          body = "<Leader>w";
          hint = "_h__j__k__l_: go | _H__J__K__L_: move | _x_: swap | _q_: close | _o_: close others | _s__v_: split | _-__+_: height | _<__>_: width | _S__V_: max | _=_: equalize | _t_: new tab";
          heads = [

            [ "h" "<C-w>h" { desc = "go left"; } ]
            [ "j" "<C-w>j" { desc = "go down"; } ]
            [ "k" "<C-w>k" { desc = "go up"; } ]
            [ "l" "<C-w>l" { desc = "go right"; } ]

            [ "H" "<C-w>H" { desc = "move left"; } ]
            [ "J" "<C-w>J" { desc = "move down"; } ]
            [ "K" "<C-w>K" { desc = "move up"; } ]
            [ "L" "<C-w>L" { desc = "move right"; } ]

            [ "x" "<C-w>x" { desc = "swap with next"; } ]

            [ "q" "<C-w>q" { desc = "close window"; } ]
            [ "o" "<C-w>o" { desc = "close other windows"; } ]

            [ "s" "<C-w>s" { desc = "split"; } ]
            [ "v" "<C-w>v" { desc = "v-split"; } ]

            [ "+" "<C-w>+" { desc = "increase height"; } ]
            [ "-" "<C-w>-" { desc = "decrease height"; } ]
            [ "<" "<C-w><" { desc = "increase width"; } ]
            [ ">" "<C-w>>" { desc = "decrease width"; } ]

            [ "S" "<C-w>_" { desc = "maximize height"; } ]
            [ "V" "<C-w>|" { desc = "maximize width"; } ]

            [ "=" "<C-w>=" { desc = "equalize width and height"; } ]

            [ "t" "<C-w>T" { desc = "break out into new tab"; } ]

          ];
          config = {
            hint.type = "cmdline";
          };
        }
      ];
    };
    plugins.which-key.registrations = {
      "<Leader>w".name = "+window";
    };
  };
}
