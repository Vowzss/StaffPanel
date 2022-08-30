include("autorun/sh_staffPanel.lua")

local function drawPanel()
    local screenWidth, screenHeight = ScrW(), ScrH()
    local hudWidth, hudHeight = screenWidth*.25, screenHeight*.25

    surface.SetDrawColor(52,52,52,255)
    surface.DrawRect(screenWidth/2 - hudWidth/2, screenHeight/2 - hudHeight/2, hudWidth, hudHeight)

    surface.SetDrawColor(210,144,52,255)
    surface.DrawRect(screenWidth/2 - hudWidth/2, screenHeight/2 - hudHeight/2, hudWidth, hudHeight/8)
end
hook.Add("HUDPaint", "staffPanelDrawPanel", drawPanel)

local function togglePanel(toggle)
    if toggle then
        staffLogger("Openning Staff Panel!", Color(0, 255, 0, 200))
    else
        staffLogger("Closing Staff Panel!", Color(255, 0, 0, 200))
    end
end

hook.Add("StaffPanelShow", "staffPanelOpenPanel", togglePanel(true))

hook.Add("StaffPanelHide", "staffPanelClosePanel", togglePanel(false))