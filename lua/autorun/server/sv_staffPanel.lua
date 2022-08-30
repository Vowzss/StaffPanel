include("autorun/sh_staffPanel.lua")

hook.Add("PlayerSay", "staffPanelPlayerSay", function(sender, text, teamChat)
    if text == "!admin" then 
        displayPrefix()
    end
end)