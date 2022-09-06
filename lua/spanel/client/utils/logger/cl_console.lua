function consoleLogger(message, color)
    MsgC(SPANEL_ADDON_THEME.logger_color, SPANEL_ADDON_CONFIG.logger, color, " " .. message .. "\n")
end