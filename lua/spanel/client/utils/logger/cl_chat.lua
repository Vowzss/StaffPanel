function chatLogger(ply, message, color)
    chat.AddText(SP_ADDON_THEME.logger_color, SP_ADDON_CONFIG.logger, color, " " .. message)
end