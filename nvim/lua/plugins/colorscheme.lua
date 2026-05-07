-- lua/plugins/colorscheme.lua
-- Tokyonight is een veilige keuze: actief onderhouden, goede integratie met
-- vrijwel elke plugin. Vervang gerust door catppuccin, kanagawa, gruvbox, etc.

return {
  {
    "folke/tokyonight.nvim",
    lazy = false,       -- colorscheme moet meteen laden
    priority = 1000,    -- ... en als eerste, voor andere plugins gehighlight worden
    opts = {
      style = "night",  -- "storm" | "night" | "moon" | "day"
      transparent = false,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },
}
