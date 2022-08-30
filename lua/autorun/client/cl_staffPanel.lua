include("autorun/sh_staffPanel.lua")

hook.Add("HUDPaint", "staffPanelHUDPaint", drawHUD)

function drawHUD()
    local screenWidth, screenHeight = ScrW(), ScrH()
    local hudWidth, hudHeight = screenWidth*.25, screenHeight*.25

    surface.SetDrawColor(52,52,52,255)
    surface.DrawRect(screenWidth/2 - hudWidth/2, screenHeight/2 - hudHeight/2, hudWidth, hudHeight)

    surface.SetDrawColor(210,144,52,255)
    surface.DrawRect(screenWidth/2 - hudWidth/2, screenHeight/2 - hudHeight/2, hudWidth, hudHeight/8)
end