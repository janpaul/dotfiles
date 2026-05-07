-- ~/.config/nvim/init.lua
-- Entrypoint. Houd dit klein, alle echte config staat in lua/

require("config.options")
require("config.keymaps")
require("config.lazy")    -- bootstrap + load plugins
