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
            STAFF_PANEL.CloseFrame()
        else
            STAFF_PANEL.OpenFrame()
        end
    end
end

function STAFF_PANEL.DisplayFrameButtons()
    toggleStaffModeButton = STAFF_PANEL.Frame:Add("DButton")
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
            STAFF_PANEL.Frame:SetTitle("StaffPanel - Manager | [Enabled]")
        else
            STAFF_PANEL.Frame:SetTitle("StaffPanel - Manager | [Disabled]")
        end
    end
end

function STAFF_PANEL.HandleFrameResize(height, frame)
    frame.OnSizeChanged = function(this, width, height) 
        if (isAnimating) then
            this:Center()
        end
        toggleStaffModeButton:SetTall(height * 0.1)
    end
end

function STAFF_PANEL.HandleFrameAnimation(width, height, frame)
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

function STAFF_PANEL.HandleFrameKeys(frame)
    frame.OnKeyCodePressed = function(self, key) 
        keyHandler(key) 
    end
end

function STAFF_PANEL.CreateFrame()
    STAFF_PANEL.Frame = vgui.Create("DFrame")
    STAFF_PANEL.Frame:SetTitle("StaffPanel - Manager")
    STAFF_PANEL.Frame:MakePopup(true)
    STAFF_PANEL.Frame:SetDraggable(true)
    STAFF_PANEL.Frame:SetBackgroundBlur(true)
    STAFF_PANEL.Frame:SetScreenLock(true)
    STAFF_PANEL.Frame:SetDeleteOnClose(true)

    STAFF_PANEL.Frame:SetSize(0, 0)
    STAFF_PANEL.Frame:Center()
end

function STAFF_PANEL.DrawFrame()
    STAFF_PANEL.Frame.Paint = function(this, width, height)
        surface.SetDrawColor(52,52,52,255)
        surface.DrawRect(0, 0, width, height)

        surface.SetDrawColor(210,144,52,255)
        surface.DrawRect(0, 0, width, height/11)
    end
end

function STAFF_PANEL.OpenFrame()
    chatLogger(LocalPlayer(), "Openning Staff Panel!", Color(0,255,0))
    staffPanelOpenned = true

    STAFF_PANEL.CreateFrame()
    STAFF_PANEL.DrawFrame()

    STAFF_PANEL.DisplayFrameButtons()

    STAFF_PANEL.HandleFrameAnimation(ScrW()*0.25, ScrH()*0.25, STAFF_PANEL.Frame)
    STAFF_PANEL.HandleFrameResize(height, STAFF_PANEL.Frame)
    STAFF_PANEL.HandleFrameKeys(STAFF_PANEL.Frame)
end
concommand.Add("openStaffPanel", STAFF_PANEL.OpenFrame)

function STAFF_PANEL.CloseFrame()
    chatLogger(LocalPlayer(), "Closing Staff Panel!", Color(255,0,0))
    staffPanelOpenned = false

    STAFF_PANEL.HandleFrameAnimation(0, 0, STAFF_PANEL.Frame)
    STAFF_PANEL.HandleFrameResize(height, STAFF_PANEL.Frame)
end
concommand.Add("closeStaffPanel", STAFF_PANEL.CloseFrame)

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