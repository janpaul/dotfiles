-- lua/config/options.lua
-- Sane defaults. Lees dit door en pas aan naar smaak.

local opt = vim.opt

-- Leader keys (zet dit VOOR plugins laden, anders pakken plugins de oude leader)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- UI
opt.number = true              -- absolute regelnummers
opt.relativenumber = true      -- relatief tov cursor; super handig voor `5j`, `12k` etc
opt.cursorline = true
opt.signcolumn = "yes"         -- altijd zichtbaar, voorkomt geflikker met git/lsp signs
opt.termguicolors = true       -- 24-bit kleuren
opt.showmode = false           -- statusline laat al zien in welke mode je zit
opt.scrolloff = 8              -- houd 8 regels boven/onder cursor zichtbaar
opt.sidescrolloff = 8

-- Indent / tabs
opt.expandtab = true           -- tab → spaces
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.smartindent = true
opt.breakindent = true         -- gewrapte regels behouden indent

-- Search
opt.ignorecase = true
opt.smartcase = true           -- case-sensitive zodra je een hoofdletter typt
opt.hlsearch = true
opt.incsearch = true

-- Files & undo
opt.swapfile = false
opt.backup = false
opt.undofile = true            -- persistente undo, levensredder
opt.undodir = vim.fn.stdpath("state") .. "/undo"

-- Splits
opt.splitright = true          -- nieuwe vsplit rechts ipv links
opt.splitbelow = true

-- Performance / UX
opt.updatetime = 250           -- snellere CursorHold events (gitsigns, lsp hover)
opt.timeoutlen = 400           -- hoe lang wachten op multi-key sequences
opt.completeopt = "menuone,noselect"

-- Clipboard: gebruik systeem clipboard. Op Linux heb je xclip of wl-clipboard nodig.
opt.clipboard = "unnamedplus"

-- Mooie listchars als je :set list aanzet
opt.list = false
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
