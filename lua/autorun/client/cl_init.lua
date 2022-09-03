include("autorun/sh_init.lua")

surface.CreateFont("Roboto", {
    font = "Roboto",
    size = 22,
    weight = 700,
})

local closeKeyPressed = false
local staffPanelOpenned = false
local prevTime = 0

local function keyHandler(keyCode)
    closeKeyPressed = false
    if (keyCode == KEY_O and UnPredictedCurTime() > prevTime + 0.05) then
        closeKeyPressed = true
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
    toggleStaffModeButton:SetPos(10, 35)
    toggleStaffModeButton:SetSize(250,100)
    toggleStaffModeButton:SetText("")
    toggleStaffModeButton.isActive = LocalPlayer().staffModeEnabled 
    toggleStaffModeButton.Paint = function(this, width, height)
        surface.SetDrawColor(ADDON_THEME.main)

        if (this:IsHovered()) then
            surface.SetDrawColor(102,72,29)
        end

        surface.DrawRect(0,0,width,height)

        draw.SimpleText(not LocalPlayer().staffModeEnabled and "Enter Staff Mode" or "Leave Staff Mode", "Roboto", width*0.5, height*0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    toggleStaffModeButton.DoClick = function(this)
        this.isActive = not this.isActive

        net.Start("SP_NET_SV_TurnStaffMode")
        net.WriteBool(this.isActive)
        net.SendToServer()
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
    STAFF_PANEL.Frame:SetTitle("StaffPanel - Manager | " .. (LocalPlayer().staffModeEnabled and "[Enabled]" or "[Disabled]"))
    STAFF_PANEL.Frame:MakePopup(true)
    STAFF_PANEL.Frame:SetDeleteOnClose(true)
    STAFF_PANEL.Frame:SetSize(0, 0)
    STAFF_PANEL.Frame:Center()
end

function STAFF_PANEL.DrawFrame()
    STAFF_PANEL.Frame.Paint = function(this, width, height)
        surface.SetDrawColor(ADDON_THEME.background)
        surface.DrawRect(0, 0, width, height)

        surface.SetDrawColor(ADDON_THEME.main)
        surface.DrawRect(0, 0, width, height/11)
    end
end

function STAFF_PANEL.OpenFrame()
    if(staffPanelOpenned) then 
        chatLogger(LocalPlayer(), "Staff Panel is already openned!", ADDON_THEME.off_message)
        return 
    end

    chatLogger(LocalPlayer(), "Openning Staff Panel!", ADDON_THEME.on_message)

    STAFF_PANEL.CreateFrame()
    STAFF_PANEL.DrawFrame()

    STAFF_PANEL.DisplayFrameButtons()

    STAFF_PANEL.HandleFrameAnimation(ScrW()*0.25, ScrH()*0.25, STAFF_PANEL.Frame)
    STAFF_PANEL.HandleFrameResize(height, STAFF_PANEL.Frame)
    STAFF_PANEL.HandleFrameKeys(STAFF_PANEL.Frame)

    staffPanelOpenned = true

    STAFF_PANEL.Frame.OnClose = function()
        if(closeKeyPressed) then return end
        STAFF_PANEL.CloseFrame()
    end
end
concommand.Add("openStaffPanel", STAFF_PANEL.OpenFrame)

function STAFF_PANEL.CloseFrame()
    if(not staffPanelOpenned) then 
        chatLogger(LocalPlayer(), "Staff Panel isn't openned!", ADDON_THEME.off_message)
        return 
    end

    chatLogger(LocalPlayer(), "Closing Staff Panel!", ADDON_THEME.off_message)

    STAFF_PANEL.Frame:ShowCloseButton(false)
    STAFF_PANEL.HandleFrameAnimation(0, 0, STAFF_PANEL.Frame)
    STAFF_PANEL.HandleFrameResize(height, STAFF_PANEL.Frame)

    staffPanelOpenned = false
end
concommand.Add("closeStaffPanel", STAFF_PANEL.CloseFrame)

function chatLogger(ply, message, color)
    chat.AddText(ADDON_THEME.logger_color, ADDON_CONFIG.logger, color, " " .. message)
end

hook.Add("PlayerButtonDown", "SP_HK_BUTTON_DOWN", function(ply, keyCode)
    if(IsFirstTimePredicted()) then
	    keyHandler(keyCode)
    end
end)

net.Receive("SP_NET_CL_StaffModeOn", function(len, ply)
    STAFF_PANEL.Frame:SetTitle("StaffPanel - Manager | [Enabled]")

    local color = ADDON_THEME.on_message
    LocalPlayer().staffModeEnabled = net.ReadBool()
    local loggedLength = net.ReadUInt(8)

    for i=1, loggedLength, 1 do
        local message = net.ReadString()
        chatLogger(ply, message, color)
    end
end)

net.Receive("SP_NET_CL_StaffModeOff", function(len, ply)
    STAFF_PANEL.Frame:SetTitle("StaffPanel - Manager | [Disabled]")

    local color = ADDON_THEME.off_message
    LocalPlayer().staffModeEnabled = net.ReadBool()
    local loggedLength = net.ReadUInt(8)
    
    for i=1, loggedLength do
        local message = net.ReadString()
        chatLogger(ply, message, color)
    end
end)