local PANEL_WIDTH = ScrW()*0.4
local PANEL_HEIGHT = ScrH()*0.3

local panelOpenned = false;

/*surface.CreateFont("gay_font", {
    font = "Roboto",
    size = 25,
    weight = 700,
    underline =
})*/

local fieldEmpty = "You must fill this field!"

function TICKET_PANEL.DisplayFrameButtons()
    TICKET_PANEL.SendTicket = vgui.Create("DButton", TICKET_PANEL.Frame)
    TICKET_PANEL.SendTicket:SetPos(PANEL_WIDTH/2-(PANEL_WIDTH*0.3)/2, PANEL_HEIGHT - (PANEL_HEIGHT*0.15) - (PANEL_HEIGHT*0.06))
    TICKET_PANEL.SendTicket:SetSize((PANEL_WIDTH*0.3),(PANEL_HEIGHT*0.15))
    TICKET_PANEL.SendTicket:SetText("")
    TICKET_PANEL.SendTicket.Paint = function(this, width, height)
        surface.SetDrawColor(SPANEL_ADDON_THEME.main)
        
        if (this:IsHovered()) then
            surface.SetDrawColor(SPANEL_ADDON_THEME.hover)
        end
        
        surface.DrawRect(0,0,width,height)

        if (this:IsHovered()) then
            draw.SimpleText("Send Ticket!", "roboto_font", width*0.5, height*0.5, SPANEL_ADDON_THEME.main, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText("Send Ticket!", "roboto_font", width*0.5, height*0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    TICKET_PANEL.SendTicket.DoClick = function(this)
        local canSendTicket = true
        if(TICKET_PANEL.savedTitle == nil) then
            TICKET_PANEL.TitleField:SetTextColor(Color(255,0,0))
            TICKET_PANEL.TitleField:SetValue(fieldEmpty)
            canSendTicket = false
        end
        if(TICKET_PANEL.savedInfo == nil) then
            TICKET_PANEL.InfoField:SetTextColor(Color(255,0,0))
            TICKET_PANEL.InfoField:SetValue(fieldEmpty)
            canSendTicket = false
        end
        if(TICKET_PANEL.savedSteam == nil) then
            TICKET_PANEL.SteamField:SetTextColor(Color(255,0,0))
            TICKET_PANEL.SteamField:SetValue(fieldEmpty)
            canSendTicket = false
        end
        if(TICKET_PANEL.savedReason == nil) then
            TICKET_PANEL.ReasonField:SetTextColor(Color(255,0,0))
            TICKET_PANEL.ReasonField:SetValue(fieldEmpty)
            canSendTicket = false
        end

        if(canSendTicket) then
            this.isActive = not this.isActive
            chatLogger(LocalPlayer(), "Ticket sucesfully sent! Support will be assissting you shortly!", Color(0,255,0))
        end
        /*net.Start("SP_NET_SV_TURN_SMODE")
        net.WriteBool(this.isActive)
        net.SendToServer()*/
    end

    TICKET_PANEL.savedTitle = nil
    TICKET_PANEL.savedInfo = nil
    TICKET_PANEL.savedReason = nil 
    TICKET_PANEL.savedSteam = nil
end

function TICKET_PANEL.IsPanelOpenned()
    return TICKET_PANEL.panelOpenned
end

function TICKET_PANEL.HandleFrameResize(height, frame)
    frame.OnSizeChanged = function(this, width, height) 
        if (isAnimating) then
            this:Center()
        end
        TICKET_PANEL.TitleField:SetTall(height * 0.1)
        TICKET_PANEL.ReasonField:SetTall(height * 0.1)
        TICKET_PANEL.SteamField:SetTall(height * 0.1)
        TICKET_PANEL.InfoField:SetTall(height * 0.378)
    end
end

function TICKET_PANEL.HandleFrameAnimation(width, height, frame)
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

function TICKET_PANEL.HandleFrameKeys(frame)
    frame.OnKeyCodePressed = function(self, key) 
        keyHandler(key) 
    end
end

function TICKET_PANEL.CreateFrame()
    TICKET_PANEL.Frame = vgui.Create("DFrame")
    TICKET_PANEL.Frame:SetTitle("Ticket Panel")
    TICKET_PANEL.Frame:MakePopup(true)
    TICKET_PANEL.Frame:SetDeleteOnClose(true)
    TICKET_PANEL.Frame:SetSize(0, 0)
    TICKET_PANEL.Frame:Center()
end

local function handleTextEntry(textEntry, currText, prevText, maxLength)
    if(#currText > maxLength) then
        textEntry:SetTextColor(Color(255,0,0))
        return prevText
    else
        if(textEntry:GetTextColor() != Color(0,0,0)) then
            textEntry:SetTextColor(Color(0,0,0))
        end
        return currText
    end
end

local function resetTextEntry(currText)
    if(currText:GetValue() == fieldEmpty or currText:GetValue() == "") then
        return currText:SetValue("")
    end
end

function TICKET_PANEL.DrawEntry() 
    TICKET_PANEL.TitleField = vgui.Create("DTextEntry", TICKET_PANEL.Frame)
    TICKET_PANEL.TitleField:SetPos((PANEL_WIDTH*0.1)/2, PANEL_HEIGHT - (PANEL_HEIGHT*0.66))
    TICKET_PANEL.TitleField:SetSize(250,nil)
	TICKET_PANEL.TitleField:SetPlaceholderText("Ticket Title (max: 38)")
    TICKET_PANEL.TitleField:SetDrawBorder(false)
    TICKET_PANEL.TitleField.OnGetFocus = function(self)
        TICKET_PANEL.savedTitle = resetTextEntry(self)
    end

    TICKET_PANEL.TitleField.OnTextChanged = function(self)
        TICKET_PANEL.savedTitle = handleTextEntry(TICKET_PANEL.TitleField, self:GetValue(), TICKET_PANEL.savedTitle, 38)
    end

    TICKET_PANEL.SteamField = vgui.Create("DTextEntry", TICKET_PANEL.Frame)
    TICKET_PANEL.SteamField:SetPos((PANEL_WIDTH*0.1)/2, PANEL_HEIGHT - (PANEL_HEIGHT*0.52))
    TICKET_PANEL.SteamField:SetSize(250,nil)
	TICKET_PANEL.SteamField:SetPlaceholderText("Player SteamID (max: 17)")
    TICKET_PANEL.SteamField.OnGetFocus = function(self)
        TICKET_PANEL.savedSteam = resetTextEntry(self)
    end

	TICKET_PANEL.SteamField.OnTextChanged = function(self)
        TICKET_PANEL.savedSteam = handleTextEntry(TICKET_PANEL.SteamField, self:GetValue(), TICKET_PANEL.savedSteam, 17)
    end

    TICKET_PANEL.ReasonField = vgui.Create("DTextEntry", TICKET_PANEL.Frame)
    TICKET_PANEL.ReasonField:SetPos((PANEL_WIDTH*0.1)/2, PANEL_HEIGHT - (PANEL_HEIGHT*0.38))
    TICKET_PANEL.ReasonField:SetSize(250,nil)
	TICKET_PANEL.ReasonField:SetPlaceholderText("Ticket Reason (max: 38)")
    TICKET_PANEL.ReasonField.OnGetFocus = function(self)
        TICKET_PANEL.savedReason = resetTextEntry(self)
    end

	TICKET_PANEL.ReasonField.OnTextChanged = function(self)
        TICKET_PANEL.savedReason = handleTextEntry(TICKET_PANEL.ReasonField, self:GetValue(), TICKET_PANEL.savedReason, 38)
    end

    TICKET_PANEL.InfoField = vgui.Create("DTextEntry", TICKET_PANEL.Frame)
    TICKET_PANEL.InfoField:SetPos((PANEL_WIDTH*0.8)/2, PANEL_HEIGHT - (PANEL_HEIGHT*0.66))
    TICKET_PANEL.InfoField:SetSize(420,nil)
	TICKET_PANEL.InfoField:SetPlaceholderText("Ticket Explanations (max: 355)")
    TICKET_PANEL.InfoField:SetMultiline(true)
    TICKET_PANEL.InfoField.OnGetFocus = function(self)
        TICKET_PANEL.savedInfo = resetTextEntry(self)
    end

    TICKET_PANEL.InfoField.OnTextChanged = function(self)
        TICKET_PANEL.savedInfo = handleTextEntry(TICKET_PANEL.InfoField, self:GetValue(), TICKET_PANEL.savedInfo, 355)
    end
end

function TICKET_PANEL.DrawFrame()
    TICKET_PANEL.Frame.Paint = function(this, width, height)
        surface.SetDrawColor(SPANEL_ADDON_THEME.background)
        surface.DrawRect(0, 0, width, height)

        surface.SetDrawColor(SPANEL_ADDON_THEME.main)
        surface.DrawRect(0, 0, width, height/11)

        surface.SetDrawColor(SPANEL_ADDON_THEME.main)
        surface.DrawRect(30, 60, width-60, height-140)

        local title = "Fill the fields to send us a ticket!"
        draw.SimpleText(title, "roboto_font", width/2, height*0.25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        
        surface.SetDrawColor(color_white)
        surface.DrawLine((width-surface.GetTextSize(title))/2, height*0.28, (width+surface.GetTextSize(title))/2, height*0.28)
    end
end

function TICKET_PANEL.ClosePanel()
    if(not TICKET_PANEL.IsPanelOpenned()) then 
        chatLogger(LocalPlayer(), "Ticket Panel isn't openned!", SPANEL_ADDON_THEME.off_message)
        return 
    end

    chatLogger(LocalPlayer(), "Closing Ticket Panel!", SPANEL_ADDON_THEME.off_message)
    TICKET_PANEL.panelOpenned = false

    TICKET_PANEL.Frame:ShowCloseButton(false)
    TICKET_PANEL.HandleFrameAnimation(0, 0, TICKET_PANEL.Frame)
    TICKET_PANEL.HandleFrameResize(height, TICKET_PANEL.Frame)
end

function TICKET_PANEL.OpenPanel()
    if(TICKET_PANEL.IsPanelOpenned()) then 
        chatLogger(LocalPlayer(), "Ticket Panel is already openned!", SPANEL_ADDON_THEME.off_message)
        return 
    end

    chatLogger(LocalPlayer(), "Openning Ticket Panel!", SPANEL_ADDON_THEME.on_message)
    TICKET_PANEL.panelOpenned = true

    TICKET_PANEL.CreateFrame()
    TICKET_PANEL.DrawFrame()

    TICKET_PANEL.DrawEntry()

    TICKET_PANEL.DisplayFrameButtons()

    TICKET_PANEL.HandleFrameAnimation(PANEL_WIDTH, PANEL_HEIGHT, TICKET_PANEL.Frame)
    TICKET_PANEL.HandleFrameResize(height, TICKET_PANEL.Frame)
    TICKET_PANEL.HandleFrameKeys(TICKET_PANEL.Frame)

    TICKET_PANEL.Frame.OnClose = function()
        if(keyPressed) then return end
        TICKET_PANEL.ClosePanel()
    end
end