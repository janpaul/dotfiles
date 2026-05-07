-- lua/plugins/lsp.lua
-- LSP setup voor Neovim 0.11+ met de nieuwe vim.lsp.config API.
--
-- Hoe het werkt:
--   1. Mason installeert language servers (binaries).
--   2. mason-lspconfig (v2+) doet automatisch vim.lsp.enable() voor alles wat
--      via Mason geïnstalleerd is — geen handmatige loop meer nodig.
--   3. nvim-lspconfig levert alleen nog de configs (in zijn `lsp/` folder);
--      het is een data-only plugin geworden, geen "framework".
--   4. Eigen overrides per server doe je met vim.lsp.config('<naam>', {...}).
--   5. on_attach is nu globaal via een LspAttach autocmd — dat triggert
--      vanzelf voor élke LSP die ergens attached, dus ook voor talen die je
--      later toevoegt zonder dat je hier iets hoeft aan te passen.

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "mason-org/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- ── Capabilities ──────────────────────────────────────────────────────
      -- Vertel servers wat de client kan (snippets, completion items, etc).
      -- We zetten dit als default voor ALLE servers via vim.lsp.config('*').
      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
      )

      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      -- ── Per-server overrides ──────────────────────────────────────────────
      -- Voeg hier servers toe die niet-default settings nodig hebben.
      -- "Lege" servers (pyright, rust_analyzer, etc.) worden automatisch
      -- enabled door mason-lspconfig met de defaults uit nvim-lspconfig's
      -- lsp/ directory; je hoeft ze hier niet expliciet te configureren.
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = { globals = { "vim" } },  -- erken `vim` als globale
          },
        },
      })

      -- ── Welke servers automatisch installeren ────────────────────────────
      local ensure_installed = {
        "lua_ls",
        -- Voeg toe naar smaak. Lijst: :h lspconfig-all
        -- "pyright", "rust_analyzer", "ts_ls", "gopls", "clangd",
      }

      require("mason-lspconfig").setup({
        ensure_installed = ensure_installed,
        automatic_enable = true,  -- doet vim.lsp.enable() voor installed servers
      })

      -- ── Keymaps via LspAttach autocmd ────────────────────────────────────
      -- Triggert wanneer een LSP attached aan een buffer. Voordeel boven de
      -- oude on_attach-per-server: één plek, werkt voor alle servers
      -- (huidige én toekomstige) zonder duplicatie.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, fn, desc)
            vim.keymap.set("n", keys, fn, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("gd", vim.lsp.buf.definition, "Goto definition")
          map("gr", vim.lsp.buf.references, "References")
          map("gI", vim.lsp.buf.implementation, "Goto implementation")
          map("K", vim.lsp.buf.hover, "Hover docs")
          map("<leader>rn", vim.lsp.buf.rename, "Rename")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("[d", function() vim.diagnostic.jump({ count = -1 }) end, "Prev diagnostic")
          map("]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
          map("<leader>e", vim.diagnostic.open_float, "Show diagnostic")
        end,
      })

      -- ── Diagnostic UI ────────────────────────────────────────────────────
      -- Sinds 0.10+ doe je signs via vim.diagnostic.config — niet meer met
      -- sign_define. Stuk schoner.
      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.INFO]  = " ",
            [vim.diagnostic.severity.HINT]  = " ",
          },
        },
        virtual_text = {
          source = "if_many",
          spacing = 2,
        },
      })
    end,
  },
}
