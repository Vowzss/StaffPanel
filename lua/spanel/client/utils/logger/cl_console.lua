function consoleLogger(message, color)
    MsgC(SP_ADDON_THEME.logger_color, SP_ADDON_CONFIG.logger, color, " " .. message .. "\n")
end