local PANEL_WIDTH = ScrW()*0.15
local PANEL_HEIGHT = ScrH()*0.2

TICKET = {}

surface.CreateFont("roboto_font_13", {
    font = "Roboto",
    size = 13,
    weight = 700,
})

function TICKET.CreateFrame()
    LocalPlayer():SetNWString("playerName", "Augustin DeBourguisson")

    TICKET.Frame = vgui.Create("DFrame")
    TICKET.Frame:SetTitle("Ticket - " .. LocalPlayer():GetNWString("playerName") .. " - [Waiting...]")
    TICKET.Frame:SetDeleteOnClose(true)
    TICKET.Frame:ShowCloseButton(false)
    TICKET.Frame:SetDraggable(false)
    TICKET.Frame:SetSize(PANEL_WIDTH, PANEL_HEIGHT)
    TICKET.Frame:SetPos(5,5)
    LocalPlayer():SetNWBool("ticketInProgress", false)
end

function TICKET.IsPanelOpenned()
    return TICKET.panelOpenned
end

function TICKET.DisplayFrameButtons()
    TICKET.ClaimTicket = vgui.Create("DButton", TICKET.Frame)
    TICKET.ClaimTicket:SetPos(PANEL_WIDTH-(PANEL_WIDTH*0.35), PANEL_HEIGHT - (PANEL_HEIGHT*0.05) - (PANEL_HEIGHT*0.11))
    TICKET.ClaimTicket:SetSize((PANEL_WIDTH*0.3),(PANEL_HEIGHT*0.05))
    TICKET.ClaimTicket:SetText("")
    TICKET.ClaimTicket.Paint = function(this, width, height)
        surface.SetDrawColor(SP_ADDON_THEME.main)
        if (this:IsHovered()) then surface.SetDrawColor(SP_ADDON_THEME.hover) end
        surface.DrawRect(0,0,width,height)

        if (this:IsHovered()) then
            draw.SimpleText("Claim Ticket", "roboto_font_13", width*0.5, height*0.5, SP_ADDON_THEME.main, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText("Claim Ticket", "roboto_font_13", width*0.5, height*0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end
    TICKET.ClaimTicket.DoClick = function(this)
        if(not LocalPlayer():GetNWBool("ticketInProgress")) then
            LocalPlayer():SetNWBool("ticketInProgress", true)
            TICKET.Frame:SetTitle("Ticket - " .. LocalPlayer():GetNWString("playerName") .. " - [In Progress...]")
            chatLogger(LocalPlayer(), "Ticket claimed! Support will arrive shortly...", Color(0,255,0))
        else
            chatLogger(LocalPlayer(), "Ticket claimed! Support will arrive shortly...", Color(255,0,0))
        end
    end

    TICKET.CancelTicket = vgui.Create("DButton", TICKET.Frame)
    TICKET.CancelTicket:SetPos(PANEL_WIDTH-(PANEL_WIDTH*0.35), PANEL_HEIGHT - (PANEL_HEIGHT*0.05) - (PANEL_HEIGHT*0.31))
    TICKET.CancelTicket:SetSize((PANEL_WIDTH*0.3),(PANEL_HEIGHT*0.05))
    TICKET.CancelTicket:SetText("")
    TICKET.CancelTicket.Paint = function(this, width, height)
        surface.SetDrawColor(SP_ADDON_THEME.main)
        if (this:IsHovered()) then surface.SetDrawColor(SP_ADDON_THEME.hover) end
        surface.DrawRect(0,0,width,height)

        if (this:IsHovered()) then
            draw.SimpleText("Cancel Ticket", "roboto_font_13", width*0.5, height*0.5, SP_ADDON_THEME.main, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText("Cancel Ticket", "roboto_font_13", width*0.5, height*0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    TICKET.CancelTicket.DoClick = function(this)
        LocalPlayer():SetNWBool("ticketInProgress", false)
        TICKET.ClosePanel()
    end
end

function TICKET.DrawFrame()
    TICKET.Frame.Paint = function(self, width, height)
        surface.SetDrawColor(SP_ADDON_THEME.background)
        surface.DrawRect(0, 0, width, height)

        if(LocalPlayer():GetNWBool("ticketInProgress")) then
            surface.SetDrawColor(Color(0,0,255))
        else
            surface.SetDrawColor(SP_ADDON_THEME.main)
        end
        surface.DrawRect(0, 0, width, height/4.5)

        surface.SetDrawColor(SP_ADDON_THEME.main)
        draw.SimpleText("Title - ".. TICKET.data.title, "roboto_font_13", 10, height*0.3, SP_ADDON_THEME.main, 0, 0)
        draw.SimpleText("Reason - ".. TICKET.data.reason, "roboto_font_13", 10, height*0.5, SP_ADDON_THEME.main, 0, 0)
        draw.SimpleText("SteamID - ".. TICKET.data.steamid, "roboto_font_13", 10, height*0.7, SP_ADDON_THEME.main, 0, 0)
        draw.SimpleText("Details ".. TICKET.data.info, "roboto_font_13", 10, height*0.9, SP_ADDON_THEME.main, 0, 0)
    end
end

function TICKET.ClosePanel()
    if(not TICKET.IsPanelOpenned()) then 
        chatLogger(LocalPlayer(), "Ticket isn't openned!", SP_ADDON_THEME.off_message)
        return 
    end

    chatLogger(LocalPlayer(), "Closing Ticket!", SP_ADDON_THEME.off_message)
    TICKET.panelOpenned = false
    TICKET.Frame:Close()
end

function TICKET.OpenPanel()
    if(TICKET.IsPanelOpenned()) then 
        chatLogger(LocalPlayer(), "Ticket is already openned!", SP_ADDON_THEME.off_message)
        return 
    end

    chatLogger(LocalPlayer(), "Openning Ticket!", SP_ADDON_THEME.on_message)
    TICKET.panelOpenned = true

    TICKET.CreateFrame()
    TICKET.DrawFrame()
    TICKET.DisplayFrameButtons()
end

net.Receive("SP_NET_CL_REGISTER_TICKET", function(len, ply)
    TICKET.data = {}
    
    TICKET.data.title = net.ReadString()
    TICKET.data.steamid = net.ReadString()
    TICKET.data.reason = net.ReadString()
    TICKET.data.info = net.ReadString()
    
    TICKET.OpenPanel()
end)