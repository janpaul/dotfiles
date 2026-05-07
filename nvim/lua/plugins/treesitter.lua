-- lua/plugins/treesitter.lua
-- Treesitter, nieuwe `main` branch (2025 rewrite).
--
-- BELANGRIJK — wat er is veranderd t.o.v. de oude API:
--   * Geen `require("nvim-treesitter.configs").setup(...)` meer.
--   * Geen `ensure_installed` table; je installeert parsers expliciet via
--     `require("nvim-treesitter").install({...})`.
--   * Highlight/indent/folding worden NIET meer automatisch aangezet door de
--     plugin. Je moet ze zelf per buffer enabled via `vim.treesitter.start()`
--     en `vim.wo.foldexpr`/`vim.bo.indentexpr`. Dat doen we via een FileType
--     autocmd hieronder — gebeurt voor jou automatisch zodra je een file
--     opent waar een parser voor bestaat.
--   * De plugin levert nu alleen nog parsers en queries. Highlighting zelf
--     zit in Neovim core.
--
-- Resultaat: zelfde gebruikerservaring als voorheen (highlight + indent
-- gewoon aan), alleen de plumbing is anders.

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,            -- main branch raadt aan dit eager te laden
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")

      -- Parsers die je altijd geïnstalleerd wilt hebben.
      -- Voeg toe naar smaak. Volledige lijst: :h treesitter-parsers
      local ensure_installed = {
        "lua", "vim", "vimdoc", "query",
        "bash", "json", "yaml", "toml", "markdown", "markdown_inline",
        -- "python", "rust", "go", "tsx", "typescript", "c", "cpp",
      }

      -- Installeer ontbrekende parsers bij startup. `:wait()` blokkeert
      -- tot install klaar is — eerste keer duurt dat even, daarna instant.
      ts.install(ensure_installed, { summary = false }):wait(30000)

      -- Lijst alle parsers die ergens in runtimepath beschikbaar zijn (built-in
      -- of via nvim-treesitter geïnstalleerd). We checken hier tegen, zodat we
      -- geen install-pogingen doen voor filetypes die helemaal geen parser
      -- hebben (zoals `alpha`, `lazy`, `mason`, etc).
      local available = {}
      for _, parser in ipairs(vim.api.nvim_get_runtime_file("parser/*", true)) do
        available[vim.fn.fnamemodify(parser, ":t:r")] = true
      end

      -- Filetypes waarvoor we sowieso niets willen doen (UI buffers van plugins)
      local skip_filetypes = {
        alpha = true, lazy = true, mason = true, TelescopePrompt = true,
        gitcommit = true,  -- heeft eigen built-in highlighting
      }

      -- Bij elk geopend file: zorg dat parser er is, start highlight + folding.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user-treesitter", { clear = true }),
        callback = function(event)
          local ft = event.match
          if not ft or ft == "" or skip_filetypes[ft] then return end

          local lang = vim.treesitter.language.get_lang(ft) or ft

          -- Als de parser er nog niet is, probeer 'm te installeren.
          -- Skip stilletjes als deze taal geen parser heeft in de registry.
          if not available[lang] then
            local ok, task = pcall(ts.install, { lang }, { summary = false })
            if not ok or not task then return end
            task:wait(10000)
            available[lang] = true
          end

          -- Highlighting aanzetten voor deze buffer
          if not pcall(vim.treesitter.start, event.buf, lang) then return end

          -- Folding op basis van treesitter (werkt vrijwel overal goed)
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.wo.foldmethod = "expr"
          vim.wo.foldenable = false  -- start unfolded; gebruik `zc`/`zo` om te folden

          -- Indent o.b.v. treesitter (kan in zeldzame gevallen wonky zijn —
          -- als je voor een bepaalde taal liever de classic indent wil,
          -- comment de regel hieronder en zet hem achter een filetype check)
          vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}
