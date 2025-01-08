return {
  "norcalli/nvim-colorizer.lua",

  config = function()
    require("colorizer").setup(
      { "*" }, -- colorize all filetypes
      { RGB = true, RRGGBB = true, RRGGBBAA = true, names = true, rgb_fn = true, hsl_fn = true }
    )
  end,

  event = "BufRead",
}
