include("autorun/sh_init.lua")

function chatLogger(ply, message, color)
    chat.AddText(ADDON_THEME.logger_color, ADDON_CONFIG.logger, color, " " .. message)
end