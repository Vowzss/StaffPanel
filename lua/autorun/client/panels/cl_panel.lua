include("autorun/sh_init.lua")

include("autorun/client/utils/logger/cl_chat.lua")
include("autorun/client/handlers/cl_keys.lua")

local panelWidth = ScrW()*0.4
local panelHeight = ScrH()*0.4

isPanelOpenned = false

function STAFF_PANEL:DisplayFrameButtons()
    toggleSMode = STAFF_PANEL.Frame:Add("DButton")
    toggleSMode:SetPos(10, 35)
    toggleSMode:SetSize(250,100)
    toggleSMode:SetText("")
    toggleSMode.isActive = LocalPlayer():GetNWBool("SP_NW_S_ENABLED") 
    toggleSMode.Paint = function(this, width, height)
        surface.SetDrawColor(ADDON_THEME.main)

        if (this:IsHovered()) then
            surface.SetDrawColor(102,72,29)
        end

        surface.DrawRect(0,0,width,height)
        draw.SimpleText(not LocalPlayer():GetNWBool("SP_NW_S_ENABLED") and "Enter SMode" or "Leave SMode", "Roboto", width*0.5, height*0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    toggleSMode.DoClick = function(this)
        this.isActive = not this.isActive

        net.Start("SP_NET_SV_TURN_S_MODE")
        net.WriteBool(this.isActive)
        net.SendToServer()
    end
end

function STAFF_PANEL:IsPanelOpenned()
    return isPanelOpenned
end

function STAFF_PANEL:HandleFrameResize(height, frame)
    frame.OnSizeChanged = function(this, width, height) 
        if (isAnimating) then
            this:Center()
        end
        toggleSMode:SetTall(height * 0.1)
    end
end

function STAFF_PANEL:HandleFrameAnimation(width, height, frame)
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

function STAFF_PANEL:HandleFrameKeys(frame)
    frame.OnKeyCodePressed = function(self, key) 
        keyHandler(key) 
    end
end

function STAFF_PANEL:CreateFrame()
    STAFF_PANEL.Frame = vgui.Create("DFrame")
    STAFF_PANEL.Frame:SetTitle("SPanel - Manager | " .. (LocalPlayer():GetNWBool("SP_NW_SMODE_ENABLED") and "[Enabled]" or "[Disabled]"))
    STAFF_PANEL.Frame:MakePopup(true)
    STAFF_PANEL.Frame:SetDeleteOnClose(true)
    STAFF_PANEL.Frame:SetSize(0, 0)
    STAFF_PANEL.Frame:Center()
end

function STAFF_PANEL:DrawFrame()
    STAFF_PANEL.Frame.Paint = function(this, width, height)
        surface.SetDrawColor(ADDON_THEME.background)
        surface.DrawRect(0, 0, width, height)

        surface.SetDrawColor(ADDON_THEME.main)
        surface.DrawRect(0, 0, width, height/11)
    end
end

function STAFF_PANEL:OpenFrame()
    if(isPanelOpenned) then 
        chatLogger(LocalPlayer(), "SPanel is already openned!", ADDON_THEME.off_message)
        return 
    end

    chatLogger(LocalPlayer(), "Openning SPanel!", ADDON_THEME.on_message)

    STAFF_PANEL:CreateFrame()
    STAFF_PANEL:DrawFrame()

    STAFF_PANEL:DisplayFrameButtons()

    STAFF_PANEL:HandleFrameAnimation(panelWidth, panelHeight, STAFF_PANEL.Frame)
    STAFF_PANEL:HandleFrameResize(height, STAFF_PANEL.Frame)
    STAFF_PANEL:HandleFrameKeys(STAFF_PANEL.Frame)

    isPanelOpenned = true

    STAFF_PANEL.Frame.OnClose = function()
        if(closeKeyPressed) then return end
        STAFF_PANEL:CloseFrame()
    end
end
concommand.Add("openSPanel", STAFF_PANEL:OpenFrame())

function STAFF_PANEL:CloseFrame()
    if(not isPanelOpenned) then 
        chatLogger(LocalPlayer(), "SPanel isn't openned!", ADDON_THEME.off_message)
        return 
    end

    chatLogger(LocalPlayer(), "Closing SPanel!", ADDON_THEME.off_message)

    STAFF_PANEL.Frame:ShowCloseButton(false)
    STAFF_PANEL.HandleFrameAnimation(0, 0, STAFF_PANEL.Frame)
    STAFF_PANEL.HandleFrameResize(height, STAFF_PANEL.Frame)

    isPanelOpenned = false
end
concommand.Add("closeSPanel", STAFF_PANEL:CloseFrame())

net.Receive("SP_NET_CL_SMODE_ENABLED", function(len, ply)
    STAFF_PANEL.Frame:SetTitle("SPanel - Manager | [Enabled]")

    local color = ADDON_THEME.on_message
    local loggedLength = net.ReadUInt(8)

    for i=1, loggedLength, 1 do
        local message = net.ReadString()
        chatLogger(ply, message, color)
    end
end)

net.Receive("SP_NET_CL_S_DISABLED", function(len, ply)
    STAFF_PANEL.Frame:SetTitle("SPanel - Manager | [Disabled]")

    local color = ADDON_THEME.off_message
    local loggedLength = net.ReadUInt(8)

    for i=1, loggedLength do
        local message = net.ReadString()
        chatLogger(ply, message, color)
    end
end)