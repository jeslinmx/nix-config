return {
  { "tpope/vim-sleuth", event = "FileType" },
  { "tpope/vim-eunuch",
    cmd = { "Remove", "Unlink", "Delete", "Copy", "Duplicate", "Move", "Rename", "Chmod", "Mkdir", "Cfind", "Lfind", "Clocate", "Llocate", "SudoEdit", "SudoWrite", "Wall", "W" },
    keys = { { "<cr>", mode = "i" } },
  },
  { "tpope/vim-unimpaired", event = "VeryLazy", dependencies = { "tpope/vim-repeat" } },
  { "tpope/vim-speeddating", keys = { "<C-a>", "<C-x>" }, dependencies = { "tpope/vim-repeat" } },
}
