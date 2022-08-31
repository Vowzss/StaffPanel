ADDON_CONFIG = {
    ["name"] = "StaffPanel",
    ["author"] = "NoIdeaIndustry",
    ["version"] = "1.0.0",

    ["logger"] = "[Logger - StaffPanel]",
    ["color"] = Color(210,144,52)
}

function consoleLogger(message, color)
    MsgC(ADDON_CONFIG.color, ADDON_CONFIG.logger, color, " " .. message .. "\n")
end

STAFF_PANEL = {}