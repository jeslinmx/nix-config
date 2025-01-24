local Mcustom = {}
Mcustom.attached_lsp = {}
local gr = vim.api.nvim_create_augroup("MiniCustom", {})
vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
  group = gr,
  pattern = "*",
  desc = "Track LSP clients",
  callback = vim.schedule_wrap(function(data)
    Mcustom.attached_lsp[data.buf] = vim.lsp.get_clients { bufnr = data.buf }
    vim.cmd "redrawstatus"
  end),
})

return {
  "echasnovski/mini.nvim",
  version = "*",

  config = function()
    -- statusline sections
    local section_mode = function(args)
      local CTRL_S = vim.api.nvim_replace_termcodes("<C-S>", true, true, true)
      local CTRL_V = vim.api.nvim_replace_termcodes("<C-V>", true, true, true)
      local modes = setmetatable({
        ["n"] = { long = " NORMAL", short = "", hl = "MiniStatuslineModeNormal" },
        ["v"] = { long = "󰈈 VISUAL", short = "󰈈", hl = "MiniStatuslineModeVisual" },
        ["V"] = { long = "󱀦 V-LINE", short = "󱀦", hl = "MiniStatuslineModeVisual" },
        [CTRL_V] = { long = "󱈝 V-BLCK", short = "󱈝", hl = "MiniStatuslineModeVisual" },
        ["s"] = { long = " SELECT", short = "", hl = "MiniStatuslineModeVisual" },
        ["S"] = { long = " S-LINE", short = "", hl = "MiniStatuslineModeVisual" },
        [CTRL_S] = { long = "󰒅 S-BLCK", short = "󰒅", hl = "MiniStatuslineModeVisual" },
        ["i"] = { long = "󰏫 INSERT", short = "󰏫", hl = "MiniStatuslineModeInsert" },
        ["R"] = { long = "󰯍 REPLCE", short = "󰯍", hl = "MiniStatuslineModeReplace" },
        ["c"] = { long = ":", short = ":", hl = "MiniStatuslineModeCommand" },
        ["t"] = { long = " TERMNL", short = "", hl = "MiniStatuslineModeOther" },
        ["r"] = { long = " ", short = "", hl = "MiniStatuslineModeOther" },
        ["!"] = { long = " ......", short = "", hl = "MiniStatuslineModeOther" },
      }, {
        -- By default return 'Unknown' but this shouldn't be needed
        __index = function()
          return { long = "Unknown", short = "U", hl = "%#MiniStatuslineModeOther#" }
        end,
      })
      local mode_info = modes[vim.fn.mode()]
      local mode = MiniStatusline.is_truncated(args.trunc_width) and mode_info.short or mode_info.long
      return { hl = mode_info.hl, strings = { mode } }
    end
    local section_filetype = function(args)
      local filetype = vim.bo.filetype

      -- Don't show anything if there is no filetype
      if filetype == "" then
        return ""
      end

      -- Add filetype icon
      local icon = _G.MiniIcons ~= nil and _G.MiniIcons.get("filetype", filetype) or ""

      return MiniStatusline.is_truncated(args.trunc_width) and icon or icon .. " " .. filetype
    end
    local section_filename = function(args)
      -- In terminal always use plain name
      if vim.bo.buftype == "terminal" then
        return "%t"
      end
      return MiniStatusline.is_truncated(args.trunc_width) and "%f" or "%F"
    end
    local section_filestatus = function()
      local flags = {}
      if not vim.bo.modifiable then
        flags[#flags + 1] = "󰏯"
      else
        if vim.bo.readonly then
          flags[#flags + 1] = "󰌾"
        end
        if vim.bo.modified then
          flags[#flags + 1] = "󰏫"
        end
      end
      return table.concat(flags)
    end
    local section_lsp = function(args)
      if MiniStatusline.is_truncated(args.trunc_width) then
        return ""
      end

      local bufnr = vim.api.nvim_get_current_buf()
      if not Mcustom.attached_lsp[bufnr] then
        return ""
      end

      local lsp_list = {}
      for i, v in ipairs(Mcustom.attached_lsp[bufnr]) do
        lsp_list[i] = v.name
      end
      local lsps = table.concat(lsp_list, "+")
      if lsps == "" then
        return ""
      end

      return "󰌵 " .. lsps
    end
    local section_fileencoding = function(args)
      local encoding = vim.bo.fileencoding or vim.bo.encoding
      return MiniStatusline.is_truncated(args.trunc_width) and "" or (encoding == "utf-8" and "" or encoding)
    end
    local section_fileformat = function(args)
      return MiniStatusline.is_truncated(args.trunc_width) and ""
        or ({ dos = "", unix = "", mac = "" })[vim.bo.fileformat]
    end
    local section_filesize = function(args)
      local size = vim.fn.getfsize(vim.fn.getreg "%")
      local size_str = size < 1024 and string.format("%dB", size)
        or size < 1048576 and string.format("%.2fKiB", size / 1024)
        or string.format("%.2fMiB", size / 1048576)
      return MiniStatusline.is_truncated(args.trunc_width) and "" or size_str
    end
    local section_location = function(args)
      -- Use virtual column number to allow update when past last column
      if MiniStatusline.is_truncated(args.trunc_width) then
        return "%l %v"
      end

      -- Use `virtcol()` to correctly handle multi-byte characters
      return '%02l/%02L %02v/%02{virtcol("$") - 1}'
    end
    -- UI
    require("mini.base16").setup { palette = _G.palette }
    require("mini.statusline").setup {
      content = {
        active = function()
          local MiniStatusline = require "mini.statusline"

          local small = 40
          local medium = 75
          local wide = 120
          local xwide = 140

          return MiniStatusline.combine_groups {
            section_mode { trunc_width = wide },
            {
              hl = "MiniStatuslineDevinfo",
              strings = {
                MiniStatusline.section_git { trunc_width = medium, icon = "" }
                  .. MiniStatusline.section_diff { trunc_width = small, icon = "" },
              },
            },
            { hl = "MiniStatuslineInactive", strings = {} }, -- reset color

            "%<", -- Mark general truncate point
            "%=", -- End left alignment

            {
              hl = "MiniStatuslineFilename",
              strings = {
                section_filename { trunc_width = xwide },
                section_filestatus(),
              },
            },

            "%=", -- End center alignment

            {
              hl = "MiniStatuslineDevinfo",
              strings = {
                section_lsp { trunc_width = medium },
              },
            },
            {
              hl = "MiniStatuslineFileinfo",
              strings = {
                section_fileencoding { trunc_width = small },
                section_fileformat { trunc_width = medium },
                section_filesize { trunc_width = wide },
                section_location { trunc_width = wide },
              },
            },
          }
        end,
        inactive = function()
          local MiniStatusline = require "mini.statusline"

          local small = 40
          local medium = 75
          local wide = 120
          local xwide = 140

          return MiniStatusline.combine_groups {
            {
              hl = "MiniStatuslineInactive",
              strings = {
                MiniStatusline.section_diff { trunc_width = small, icon = "" },
                "%<", -- Mark general truncate point
                "%=", -- End left alignment
                section_filename { trunc_width = xwide },
                section_filestatus(),
                "%=", -- End center alignment
              },
            },
          }
        end,
      },
    }
    require("mini.tabline").setup {
      tabpage_section = "right",
      format = function(buf_id, label)
        local levels = { vim.diagnostic.severity.WARN, vim.diagnostic.severity.ERROR }
        local icons = { [vim.diagnostic.severity.WARN] = "", [vim.diagnostic.severity.ERROR] = "" }
        local diag = vim.diagnostic.count(buf_id, { severity = levels })
        local t = {
          MiniIcons.get("filetype", vim.api.nvim_get_option_value("filetype", { buf = buf_id })),
          label,
        }
        for level, icon in ipairs(icons) do
          local n = diag[level] or 0
          if n > 0 then
            table.insert(t, icon)
            table.insert(t, n)
          end
        end
        return " " .. table.concat(t, " ") .. " "
      end,
    }
    require("mini.icons").setup()
    require("mini.icons").mock_nvim_web_devicons()
    require("mini.icons").tweak_lsp_kind()

    -- Editing
    require("mini.ai").setup()
    -- require('mini.align').setup()

    -- Mappings
    require("mini.clue").setup {
      triggers = {
        { mode = "n", keys = "<Leader>" },
        { mode = "x", keys = "<Leader>" },
        { mode = "i", keys = "<C-x>" },
        { mode = "n", keys = "g" },
        { mode = "x", keys = "g" },
        -- mark-radar handles these better
        -- { mode = "n", keys = "'" },
        -- { mode = "n", keys = "`" },
        -- { mode = "x", keys = "'" },
        -- { mode = "x", keys = "`" },
        { mode = "n", keys = '"' },
        { mode = "x", keys = '"' },
        { mode = "i", keys = "<C-r>" },
        { mode = "c", keys = "<C-r>" },
        { mode = "n", keys = "<C-w>" },
        { mode = "n", keys = "z" },
        { mode = "x", keys = "z" },
      },
      clues = (function()
        local c = require "mini.clue"
        return {
          c.gen_clues.builtin_completion(),
          c.gen_clues.g(),
          c.gen_clues.marks(),
          c.gen_clues.registers(),
          c.gen_clues.windows(),
          c.gen_clues.z(),
          { mode = { "n", "v" }, keys = "<leader>b", desc = "+Buffers" },
          { mode = { "n", "v" }, keys = "<leader>l", desc = "+LSP" },
          { mode = { "n", "v" }, keys = "<leader>t", desc = "+Trouble" },
          { mode = { "n", "v" }, keys = "<leader><leader>", desc = "+Telescope" },
          { mode = { "n", "v" }, keys = "<leader><leader>g", desc = "+Git" },
        }
      end)(),
      window = { delay = 100, config = { width = "auto" } },
    }

    -- Window/buffer management
    require("mini.sessions").setup { autoread = true, autowrite = true } -- todo: MiniSessions.write and select interactively

    -- LSP
    -- require('mini.cursorword').setup()

    require("mini.diff").setup()
    -- require('mini.extra').setup()
    require("mini.files").setup {
      windows = { preview = true, width_focus = 25, width_nofocus = 15, width_preview = 50 },
      mappings = { close = "<Esc>", go_in = "<S-CR>", go_in_plus = "<CR>", go_out = "_", go_out_plus = "-" },
    }
    require("mini.git").setup()
    -- require('mini.misc').setup()
    -- require('mini.move').setup()
    require("mini.operators").setup()
    require("mini.pairs").setup()
    -- require('mini.splitjoin').setup()
    -- require('mini.trailspace').setup()
    -- require('mini.visits').setup()
  end,

  event = "VeryLazy",
}
