local PANEL_WIDTH = ScrW()*0.4
local PANEL_HEIGHT = ScrH()*0.4

local panelOpenned = false;

function STAFF_PANEL.DisplayFrameButtons()
    toggleSMode = STAFF_PANEL.Frame:Add("DButton")
    toggleSMode:SetPos(10, 35)
    toggleSMode:SetSize(250,100)
    toggleSMode:SetText("")
    toggleSMode.isActive = LocalPlayer():GetNWBool("SP_NW_SMODE_ACTIVE") 
    toggleSMode.Paint = function(this, width, height)
        surface.SetDrawColor(SPANEL_ADDON_THEME.main)

        if (this:IsHovered()) then
            surface.SetDrawColor(102,72,29)
        end

        surface.DrawRect(0,0,width,height)
        draw.SimpleText(not LocalPlayer():GetNWBool("SP_NW_SMODE_ACTIVE") and "Enter SMode" or "Leave SMode", "roboto_font", width*0.5, height*0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    toggleSMode.DoClick = function(this)
        this.isActive = not this.isActive

        net.Start("SP_NET_SV_TURN_SMODE")
        net.WriteBool(this.isActive)
        net.SendToServer()
    end
end

function STAFF_PANEL.IsPanelOpenned()
    return STAFF_PANEL.panelOpenned
end

function STAFF_PANEL.HandleFrameResize(height, frame)
    frame.OnSizeChanged = function(this, width, height) 
        if (isAnimating) then
            this:Center()
        end
        toggleSMode:SetTall(height * 0.1)
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
    STAFF_PANEL.Frame:SetTitle("Staff Panel - Manager | " .. (LocalPlayer():GetNWBool("SP_NW_SMODE_ENABLED") and "[Enabled]" or "[Disabled]"))
    STAFF_PANEL.Frame:MakePopup(true)
    STAFF_PANEL.Frame:SetDeleteOnClose(true)
    STAFF_PANEL.Frame:SetSize(0, 0)
    STAFF_PANEL.Frame:Center()
end

function STAFF_PANEL.DrawFrame()
    STAFF_PANEL.Frame.Paint = function(this, width, height)
        surface.SetDrawColor(SPANEL_ADDON_THEME.background)
        surface.DrawRect(0, 0, width, height)

        surface.SetDrawColor(SPANEL_ADDON_THEME.main)
        surface.DrawRect(0, 0, width, height/11)
    end
end

function STAFF_PANEL.ClosePanel()
    if(not STAFF_PANEL.IsPanelOpenned()) then 
        chatLogger(LocalPlayer(), "Staff Panel isn't openned!", SPANEL_ADDON_THEME.off_message)
        return 
    end
    
    chatLogger(LocalPlayer(), "Closing Staff Panel!", SPANEL_ADDON_THEME.off_message)
    STAFF_PANEL.panelOpenned = false;

    STAFF_PANEL.Frame:ShowCloseButton(false)
    STAFF_PANEL.HandleFrameAnimation(0, 0, STAFF_PANEL.Frame)
    STAFF_PANEL.HandleFrameResize(height, STAFF_PANEL.Frame)
end
concommand.Add("closeSPanel", STAFF_PANEL.ClosePanel)

function STAFF_PANEL.OpenPanel()
    if(STAFF_PANEL.IsPanelOpenned()) then 
        chatLogger(LocalPlayer(), "Staff Panel is already openned!", SPANEL_ADDON_THEME.off_message)
        return 
    end

    chatLogger(LocalPlayer(), "Openning Staff Panel!", SPANEL_ADDON_THEME.on_message)
    STAFF_PANEL.panelOpenned = true

    STAFF_PANEL.CreateFrame()
    STAFF_PANEL.DrawFrame()

    STAFF_PANEL.DisplayFrameButtons()

    STAFF_PANEL.HandleFrameAnimation(PANEL_WIDTH, PANEL_HEIGHT, STAFF_PANEL.Frame)
    STAFF_PANEL.HandleFrameResize(height, STAFF_PANEL.Frame)
    STAFF_PANEL.HandleFrameKeys(STAFF_PANEL.Frame)

    STAFF_PANEL.Frame.OnClose = function()
        if(not keyPressed) then STAFF_PANEL.ClosePanel() end
    end
end
concommand.Add("openSPanel", STAFF_PANEL.OpenPanel)

net.Receive("SP_NET_CL_SMODE_ACTIVE", function(len, ply)
    local isActive = LocalPlayer():GetNWBool("SP_NW_SMODE_ACTIVE")

    STAFF_PANEL.Frame:SetTitle("Staff Panel - Manager | [" .. (isActive and "Enabled" or "Disabled") .. "]")

    local color = isActive and SPANEL_ADDON_THEME.on_message or SPANEL_ADDON_THEME.off_message
    local loggedLength = net.ReadUInt(8)

    for i=1, loggedLength, 1 do
        local message = net.ReadString()
        chatLogger(ply, message, color)
    end
end)