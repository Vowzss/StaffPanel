ADDON_CONFIG = {
    ["name"] = "SPanel",
    ["author"] = "NoIdeaIndustry",
    ["version"] = "1.0.0",

    ["logger"] = "[Logger - SPanel]",
}

ADDON_THEME = {
    ["logger_color"] = Color(235, 188, 186),

    ["main"] = Color(210, 144, 52),
    ["background"] = Color(52, 52, 52),

    ["on_message"] = Color(196, 167, 231),
    ["off_message"] = Color(235, 111, 146),
}

function consoleLogger(message, color)
    MsgC(ADDON_THEME.logger_color, ADDON_CONFIG.logger, color, " " .. message .. "\n")
end

STAFF_PANEL = {}