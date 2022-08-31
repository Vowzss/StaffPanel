include("autorun/sh_init.lua")

surface.CreateFont("Roboto", {
    font = "Roboto",
    size = 22,
    weight = 700,
})

local staffPanelOpenned = false
local prevTime = 0

local function keyHandler(keyCode)
    if (keyCode == KEY_O and UnPredictedCurTime() > prevTime + 0.05) then
        prevTime = UnPredictedCurTime()
        if(staffPanelOpenned) then
            STAFF_PANEL.CloseMenu()
        else
            STAFF_PANEL.OpenMenu()
        end
    end
end

function STAFF_PANEL.CreateMenu()
    STAFF_PANEL.Menu = vgui.Create("DFrame")
    STAFF_PANEL.Menu:SetTitle("StaffPanel - Manager")
    STAFF_PANEL.Menu:MakePopup(true)
    STAFF_PANEL.Menu:SetDraggable(true)
    STAFF_PANEL.Menu:SetBackgroundBlur(true)
    STAFF_PANEL.Menu:SetScreenLock(true)
    STAFF_PANEL.Menu:SetDeleteOnClose(true)

    STAFF_PANEL.Menu:SetSize(0, 0)
    STAFF_PANEL.Menu:Center()
end

function STAFF_PANEL.DrawMenu()
    STAFF_PANEL.Menu.Paint = function(this, width, height)
        surface.SetDrawColor(52,52,52,255)
        surface.DrawRect(0, 0, width, height)

        surface.SetDrawColor(210,144,52,255)
        surface.DrawRect(0, 0, width, height/11)
    end
end

function STAFF_PANEL.DisplayButtons()
    toggleStaffModeButton = STAFF_PANEL.Menu:Add("DButton")
    toggleStaffModeButton:Dock(TOP)
    toggleStaffModeButton:SetText("")
    toggleStaffModeButton.isActive = false 
    toggleStaffModeButton.Paint = function(this, width, height)
        surface.SetDrawColor(210,144,52)

        if (this:IsHovered()) then
            surface.SetDrawColor(102,72,29)
        end
    
        surface.DrawRect(0,0,width, height)
        draw.SimpleText(not staffModeEnabled and "Enter Staff Mode" or "Leave Staff Mode", "Roboto", width*0.5, height*0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    toggleStaffModeButton.DoClick = function(this)
        this.isActive = not this.isActive

        net.Start("SP_NET_SV_TurnStaffMode")
        net.WriteBool(this.isActive)
        net.SendToServer()

        if(staffModeEnabled) then
            STAFF_PANEL.Menu:SetTitle("StaffPanel - Manager | [Enabled]")
        else
            STAFF_PANEL.Menu:SetTitle("StaffPanel - Manager | [Disabled]")
        end
    end
end

function STAFF_PANEL.HandleResize(height)
    if (isAnimating) then
        this:Center()
    end
    toggleStaffModeButton:SetTall(height * 0.1)
end

function STAFF_PANEL.HandleAnimation(width, height, frame)
    local animTime, animeDelay, animeEase = 1, 0, 0.2

    local isAnimating = true;
    frame:SizeTo(width, height, animTime, animDelay, animEase, function() 
        isAnimating = false
        if(width == 0 and height == 0) then frame:Close() end
    end)

    frame.Think = function(this) 
        if (isAnimating) then
            this:Center()
        end
    end
end

function STAFF_PANEL.OpenMenu()
    chatLogger(LocalPlayer(), "Openning Staff Panel!", Color(0,255,0))
    staffPanelOpenned = true

    local screenWidth, screenHeight = ScrW(), ScrH()
    local hudWidth, hudHeight = screenWidth*.25, screenHeight*.25
    local animTime, animeDelay, animeEase = 1, 0, 0.2

    STAFF_PANEL.CreateMenu()
    STAFF_PANEL.DrawMenu()

    STAFF_PANEL.HandleAnimation(hudWidth, hudHeight, STAFF_PANEL.Menu)

    STAFF_PANEL.Menu.OnSizeChanged = function(this, width, height) 
        STAFF_PANEL.HandleResize(height)
    end

    STAFF_PANEL.DisplayButtons()

    STAFF_PANEL.Menu.OnKeyCodePressed = function(self, key) 
        keyHandler(key) 
    end
end
concommand.Add("openStaffPanel", STAFF_PANEL.OpenMenu)

function STAFF_PANEL.CloseMenu()
    chatLogger(LocalPlayer(), "Closing Staff Panel!", Color(255,0,0))
    staffPanelOpenned = false

    STAFF_PANEL.HandleAnimation(0, 0, STAFF_PANEL.Menu)

    STAFF_PANEL.Menu.OnSizeChanged = function(this, width, height) 
        STAFF_PANEL.HandleResize(height)
    end
end
concommand.Add("closeStaffPanel", STAFF_PANEL.CloseMenu)

function chatLogger(ply, message, color)
    chat.AddText(ADDON_CONFIG.color, ADDON_CONFIG.logger, color, " " .. message)
end

hook.Add("PlayerButtonDown", "SP_HK_BUTTON_DOWN", function(ply, keyCode)
    if(IsFirstTimePredicted()) then
	    keyHandler(keyCode)
    end
end)

net.Receive("SP_NET_CL_StaffModeOn", function(len, ply)
    local message = net.ReadString()
    local color = net.ReadColor()

    chatLogger(ply, message, color)
end)

net.Receive("SP_NET_CL_StaffModeOff", function(len, ply)
    local message = net.ReadString()
    local color = net.ReadColor()

    chatLogger(ply, message, color)
end)