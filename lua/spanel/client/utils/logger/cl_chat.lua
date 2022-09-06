function chatLogger(ply, message, color)
    chat.AddText(SPANEL_ADDON_THEME.logger_color, SPANEL_ADDON_CONFIG.logger, color, " " .. message)
end