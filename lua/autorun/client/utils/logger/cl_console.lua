include("autorun/sh_init.lua")

function consoleLogger(message, color)
    MsgC(ADDON_THEME.logger_color, ADDON_CONFIG.logger, color, " " .. message .. "\n")
end