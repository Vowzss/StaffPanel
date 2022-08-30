ADDON_CONFIG = {
    ["name"] = "StaffPanel",
    ["author"] = "NoIdeaIndustry",
    ["version"] = "1.0.0"
}

print()print()
print("------------------------------------")
print("---------    " .. ADDON_CONFIG.name .. "    ---------")
print("-------    " .. ADDON_CONFIG.author .. "    -------")
print("------------------------------------")
print()print()

print("Successfully loaded " .. ADDON_NAME .. " ver: " .. ADDON_CONFIG.version)

function displayPrefix()
    print("[" .. ADDON_CONFIG.name .. "]")
end