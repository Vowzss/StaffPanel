ADDON_CONFIG = {
    ["name"] = "StaffPanel",
    ["author"] = "NoIdeaIndustry",
    ["version"] = "1.0.0",

    ["logger"] = "[Logger - StaffPanel]",
    ["color"] = Color(100, 220, 100, 200)
}

function staffLogger(message, color)
    MsgC(ADDON_CONFIG.color, ADDON_CONFIG.logger, color, " " .. message .. "\n")
end

HOTANIMATIONS = {}