local opt = vim.opt
local o = vim.o
local g = vim.g

--- UI ---
o.mouse = "a"
o.splitbelow = true
o.splitright = true
o.splitkeep = "screen" -- when splitting, keep text on the current screenline
o.termguicolors = true

-- statusline and cmdline
o.showmode = false
o.ruler = false -- hide row:col and position% indicators
opt.shortmess = "IaT" -- hide Vim intro, abbreviate [readonly], [Modified] etc. messages in cmdline, truncate cmdline at middle

--- EDITOR ---
o.clipboard = "unnamedplus"
if vim.env.SSH_TTY then
  g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy "+",
      ["*"] = require("vim.ui.clipboard.osc52").copy "*",
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste "+",
      ["*"] = require("vim.ui.clipboard.osc52").paste "*",
    },
  }
end

-- Gutter
o.number = true
o.numberwidth = 2
o.signcolumn = "yes"

-- Buffers
opt.fillchars = { eob = " " } -- remove tildes from end of buffer
o.cursorline = true -- Highlight current line
o.cursorlineopt = "both" -- highlight textline and line number
o.list = true
opt.listchars:append {
  trail = "◦",
  multispace = "◦",
  leadmultispace = " ",
  nbsp = "⍽",
  precedes = "«",
  extends = "»",
}
o.foldmethod = "indent"
o.foldlevelstart = 99 -- start with no lines folded
o.wrap = true
o.breakindent = true -- Indent wrapped lines to match line start
o.linebreak = true -- Wrap long lines at 'breakat' (if 'wrap' is set)
o.sidescroll = 5
o.virtualedit = "block" -- allow moving the cursor even where there is no text, in v-block mode

-- Formatting
-- if opening a new line with <Enter>/o/O in a comment block, automatically add the comment leader
-- autoformat affects comments
-- autoformat indents multiline numbered list entries
-- do not automatically break lines on textwidth in insert mode
-- allow newlines at multibyte characters, and join them without adding spaces between
-- for one-letter words, break before rather than after them
-- remove comment leaders when joining lines
o.formatoptions = "ro/qnlmB1j"
o.smartindent = true

-- Completion
o.completeopt = "menuone,noinsert,noselect,popup"

-- Indenting
o.expandtab = true
o.shiftwidth = 2
o.smartindent = true
o.tabstop = 2
o.softtabstop = 2

-- Search
o.ignorecase = true
o.smartcase = true
o.incsearch = true

--- MAPPINGS ---
o.timeoutlen = 400
opt.whichwrap:append "<>[]hl" -- go to previous/next line with h,l,left arrow and right arrow

--- FILE HANDLING ---
o.undofile = true
o.updatetime = 250 -- interval for writing swap file to disk, also used by gitsigns
o.writebackup = true -- when writing, create a backup...
o.backupcopy = "auto" -- by renaming the original file (unless it has special attributes or is a link)...
o.backup = false -- and don't keep the backup after the write succeeds

-- disable some default providers
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
