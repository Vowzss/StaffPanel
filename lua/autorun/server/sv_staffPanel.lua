include("autorun/sh_staffPanel.lua")

print()print()
print("------------------------------------")
print("---------    " .. ADDON_CONFIG.name .. "    ---------")
print("-------    " .. ADDON_CONFIG.author .. "    -------")
print("------------------------------------")
print()print()

print("Successfully loaded " .. ADDON_CONFIG.name .. " ver: " .. ADDON_CONFIG.version)

hook.Add("PlayerSay", "staffPanelPlayerSay", function(sender, text, teamChat)
    if text == "!admin" then 
        displayPrefix()
    end
end)