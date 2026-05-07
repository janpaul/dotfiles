-- lua/plugins/telescope.lua
-- Fuzzy finder voor files, grep, buffers, LSP symbols, git, alles.
-- fzf-native = C extensie, veel sneller dan default sorter.

return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function() return vim.fn.executable("make") == 1 end,
      },
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Symbols (file)" },
      { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          mappings = {
            i = { ["<C-u>"] = false, ["<C-d>"] = false },
          },
        },
      })
      pcall(require("telescope").load_extension, "fzf")
    end,
  },
}
