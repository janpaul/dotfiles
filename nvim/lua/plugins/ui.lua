-- lua/plugins/ui.lua
-- UI laag: statusline, dashboard, file icons, en which-key
-- (which-key = popup met je keybinds als je leader indrukt — leerhulp).

return {
  -- File icons (gebruikt door lualine, telescope, etc).
  -- Vereist een Nerd Font in je terminal; anders zie je rare blokjes.
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "tokyonight",
        globalstatus = true,             -- één statusline ipv per split
        section_separators = { left = "", right = "" },
        component_separators = { left = "│", right = "│" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },  -- relatief pad
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- Dashboard / startscherm
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        [[                                                       ]],
        [[  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗  ]],
        [[  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║  ]],
        [[  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║  ]],
        [[  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║  ]],
        [[  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║  ]],
        [[  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝  ]],
      }

      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find file",     "<cmd>Telescope find_files<CR>"),
        dashboard.button("r", "  Recent files",  "<cmd>Telescope oldfiles<CR>"),
        dashboard.button("g", "  Live grep",     "<cmd>Telescope live_grep<CR>"),
        dashboard.button("n", "  New file",      "<cmd>ene <BAR> startinsert<CR>"),
        dashboard.button("c", "  Config",        "<cmd>edit $MYVIMRC<CR>"),
        dashboard.button("l", "  Lazy",          "<cmd>Lazy<CR>"),
        dashboard.button("q", "  Quit",          "<cmd>qa<CR>"),
      }

      alpha.setup(dashboard.opts)
    end,
  },

  -- which-key: popup met beschikbare keybinds. Begin gewoon aan je leader te
  -- drukken en wacht — perfect om je eigen config te leren onthouden.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
