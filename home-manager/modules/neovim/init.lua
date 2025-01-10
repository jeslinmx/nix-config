_G.palette = _G.palette
  or {
    base00 = "#000000",
    base01 = "#181825",
    base02 = "#313244",
    base03 = "#45475a",
    base04 = "#585b70",
    base05 = "#cdd6f4",
    base06 = "#f5e0dc",
    base07 = "#b4befe",
    base08 = "#f38ba8",
    base09 = "#fab387",
    base0A = "#f9e2af",
    base0B = "#a6e3a1",
    base0C = "#94e2d5",
    base0D = "#89b4fa",
    base0E = "#cba6f7",
    base0F = "#f2cdcd",
  }

-- useful helper for debugging Lua
_G.v = function(x)
  print(vim.inspect(x))
end

require "lazy_init"
require "options"
require "autocmds"
require "highlights"
vim.schedule(function()
  require "mappings"
end)
