math.randomseed(os.time())

vim.g.startify_custom_header = {
  "                                    oo            ",
  "                                                  ",
  "88d888b. .d8888b. .d8888b. dP   .dP dP 88d8b.d8b. ",
  "88'  `88 88ooood8 88'  `88 88   d8' 88 88'`88'`88 ",
  "88    88 88.  ... 88.  .88 88 .88'  88 88  88  88 ",
  "dP    dP `88888P' `88888P' 8888P'   dP dP  dP  dP ",
  ""
}
vim.g.startify_custom_footer = {
  "",
  vim.fn.system('kjv Psalms 119:' .. math.ceil(math.random() * 176)):match('^(.-)%s*$')
}
vim.g.startify_change_to_vcs_root = true
vim.g.startify_custom_indices = { "a","s","d","f","g","h","j","k","l",";" }
vim.g.startify_relative_path = true
vim.g.startify_session_persistence = true
vim.g.startify_session_sort = true
vim.g.startify_update_oldfiles = true
vim.g.startify_lists = {
  { type = "dir";
    header = { table.concat({
      '   MRU',
      vim.loop.cwd(),
      vim.fn.system('git log -1 --format="(%h %s)" 2> /dev/null')
    }, ' ') }},
  { type = "sessions", header = { "    Sessions" } },
  { type = "bookmarks", header = { "    Bookmarks" } },
  { type = "commands", header = { "    Commands" } },
}

return {
  "mhinz/vim-startify",
  lazy = false,
  keys = {{ "<leader>~", "<cmd>Startify<cr>" }}
}
