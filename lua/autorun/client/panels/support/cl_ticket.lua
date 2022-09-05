include("autorun/sh_init.lua")

include("autorun/client/utils/logger/cl_chat.lua")
include("autorun/client/handlers/cl_keys.lua")

local panelWidth = ScrW()*0.4
local panelHeight = ScrH()*0.4

isPanelOpenned = false

function createTicket(ply)
    TICKET_PANEL.Frame = vgui.Create("DFrame")
    TICKET_PANEL.Frame:SetTitle("SPanel - TICKET")
    TICKET_PANEL.Frame:MakePopup(true)
    TICKET_PANEL.Frame:SetDeleteOnClose(true)
    TICKET_PANEL.Frame:SetSize(0, 0)
    TICKET_PANEL.Frame:Center()

    TICKET_PANEL.sender = ply

    TICKET_PANEL.Frame.Paint = function(this, width, height)
        surface.SetDrawColor(ADDON_THEME.background)
        surface.DrawRect(0, 0, width, height)

        surface.SetDrawColor(ADDON_THEME.main)
        surface.DrawRect(0, 0, width, height/11)
    end
    /*net.Start("SP_NET_SV_DISPLAY_TICKET")
    net.WriteBool(this.isActive)
    net.SendToServer()*/
end

function TICKET_PANEL:HandleFrameResize(height, frame)
    frame.OnSizeChanged = function(this, width, height) 
        if (isAnimating) then
            this:Center()
        end
        toggleSMode:SetTall(height * 0.1)
        openTicket:SetTall(height * 0.1)
    end
end

function TICKET_PANEL:HandleFrameAnimation(width, height, frame)
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

function TICKET_PANEL:HandleFrameKeys(frame)
    frame.OnKeyCodePressed = function(self, key) 
        keyHandler(key) 
    end
end

function TICKET_PANEL:CreateFrame()
    TICKET_PANEL.Frame = vgui.Create("DFrame")
    TICKET_PANEL.Frame:SetTitle("SPanel - Manager | " .. (LocalPlayer():GetNWBool("SP_NW_SMODE_ENABLED") and "[Enabled]" or "[Disabled]"))
    TICKET_PANEL.Frame:MakePopup(true)
    TICKET_PANEL.Frame:SetDeleteOnClose(true)
    TICKET_PANEL.Frame:SetSize(0, 0)
    TICKET_PANEL.Frame:Center()
end

function TICKET_PANEL:DrawFrame()
    TICKET_PANEL.Frame.Paint = function(this, width, height)
        surface.SetDrawColor(ADDON_THEME.background)
        surface.DrawRect(0, 0, width, height)

        surface.SetDrawColor(ADDON_THEME.main)
        surface.DrawRect(0, 0, width, height/11)
    end
end

function TICKET_PANEL:OpenFrame()
    if(isPanelOpenned) then 
        chatLogger(LocalPlayer(), "SPanel is already openned!", ADDON_THEME.off_message)
        return 
    end

    chatLogger(LocalPlayer(), "Openning SPanel!", ADDON_THEME.on_message)

    TICKET_PANEL:CreateFrame()
    TICKET_PANEL:DrawFrame()

    TICKET_PANEL.HandleFrameAnimation(panelWidth, panelHeight, TICKET_PANEL.Frame)
    TICKET_PANEL.HandleFrameResize(height, TICKET_PANEL.Frame)
    TICKET_PANEL.HandleFrameKeys(TICKET_PANEL.Frame)

    isPanelOpenned = true

    TICKET_PANEL.Frame.OnClose = function()
        if(closeKeyPressed) then return end
        TICKET_PANEL:CloseFrame()
    end
end

function TICKET_PANEL:CloseFrame()
    if(not isPanelOpenned) then 
        chatLogger(LocalPlayer(), "SPanel isn't openned!", ADDON_THEME.off_message)
        return 
    end

    chatLogger(LocalPlayer(), "Closing SPanel!", ADDON_THEME.off_message)

    TICKET_PANEL.Frame:ShowCloseButton(false)
    TICKET_PANEL.HandleFrameAnimation(0, 0, TICKET_PANEL.Frame)
    TICKET_PANEL.HandleFrameResize(height, TICKET_PANEL.Frame)

    isPanelOpenned = false
end