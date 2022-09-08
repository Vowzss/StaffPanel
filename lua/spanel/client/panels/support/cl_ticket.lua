local PANEL_WIDTH = ScrW()*0.4
local PANEL_HEIGHT = ScrH()*0.3

local EMPTY_FIELD_ERR = "You must fill this field!"

surface.CreateFont("roboto_font", {
    font = "Roboto",
    size = 25,
    weight = 700,
})

surface.CreateFont("roboto_font_20", {
    font = "Roboto",
    size = 20,
    weight = 700,
})

local function displayFieldError(field) 
    if(field.saved == nil) then
        field:SetValue(EMPTY_FIELD_ERR)
        LocalPlayer():SetNWBool("canSendTicket", false)
    end
end

function TICKET_PANEL.DisplayFrameButtons()
    TICKET_PANEL.SendTicket = vgui.Create("DButton", TICKET_PANEL.Frame)
    TICKET_PANEL.SendTicket:SetPos(PANEL_WIDTH/2-(PANEL_WIDTH*0.3)/2, PANEL_HEIGHT - (PANEL_HEIGHT*0.15) - (PANEL_HEIGHT*0.06))
    TICKET_PANEL.SendTicket:SetSize((PANEL_WIDTH*0.3),(PANEL_HEIGHT*0.15))
    TICKET_PANEL.SendTicket:SetText("")
    TICKET_PANEL.SendTicket.Paint = function(this, width, height)
        surface.SetDrawColor(SPANEL_ADDON_THEME.main)
        if (this:IsHovered()) then surface.SetDrawColor(SPANEL_ADDON_THEME.hover) end
        surface.DrawRect(0, 0, width, height)

        if (this:IsHovered()) then
            draw.SimpleText("Send Ticket!", "roboto_font", width*0.5, height*0.5, SPANEL_ADDON_THEME.main, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText("Send Ticket!", "roboto_font", width*0.5, height*0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    TICKET_PANEL.SendTicket.DoClick = function(this)
        LocalPlayer():SetNWBool("canSendTicket", true)

        displayFieldError(TICKET_PANEL.TitleField)
        displayFieldError(TICKET_PANEL.InfoField)
        displayFieldError(TICKET_PANEL.SteamField)
        displayFieldError(TICKET_PANEL.ReasonField)


        if(LocalPlayer():GetNWBool("canSendTicket")) then
            this.isActive = not this.isActive
            if(LocalPlayer():GetNWBool("ticketInProgress")) then
                chatLogger(LocalPlayer(), "You already have a pending ticket! Wait for it to be solved...", Color(255,0,0))
            else
                chatLogger(LocalPlayer(), "Ticket sucesfully sent! Support will be assissting you shortly...", Color(0,255,0))
                LocalPlayer():SetNWBool("ticketInProgress", true)

                net.Start("SP_NET_SV_REGISTER_TICKET")
                net.WriteString(TICKET_PANEL.TitleField.saved)
                net.WriteString(TICKET_PANEL.SteamField.saved)
                net.WriteString(TICKET_PANEL.ReasonField.saved)
                net.WriteString(TICKET_PANEL.InfoField.saved)
                net.SendToServer()

                TICKET_PANEL.ClosePanel()
            end
        end
    end

    TICKET_PANEL.TitleField.saved = nil
    TICKET_PANEL.InfoField.saved  = nil
    TICKET_PANEL.SteamField.saved  = nil 
    TICKET_PANEL.ReasonField.saved  = nil
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

local function focusEntry(self, saved)
    local curValue = self:GetValue()
    if(curValue == "" or EMPTY_FIELD_ERR and saved != "") then
        self:SetValue("")
        self.focus = true
    end
end

local function drawEntry(self, width, height, textHeight, field)
    surface.SetDrawColor(SPANEL_ADDON_THEME.background)
    surface.DrawRect(0, 0, width, height)
    
    local curValue = self:GetValue()

    if(curValue == "" and not self.focus) then
        draw.DrawText(field.hint, "roboto_font_20", 5, textHeight, Color(167,154,154), 0)
        field.saved = nil
    elseif (curValue == EMPTY_FIELD_ERR) then
        draw.DrawText(EMPTY_FIELD_ERR, "roboto_font_20", 5, textHeight+2, Color(255,0,0), 0)
        field.saved = nil
    else
        draw.DrawText(curValue, "roboto_font_20", 5, textHeight, Color(255,255,255), 0)
        field.saved = curValue
    end
end

function TICKET_PANEL.DrawCombo()
    TICKET_PANEL.ReasonField = vgui.Create("DComboBox",  TICKET_PANEL.Frame)
    TICKET_PANEL.ReasonField:SetPos((PANEL_WIDTH*0.1)/2, PANEL_HEIGHT - (PANEL_HEIGHT*0.38))
    TICKET_PANEL.ReasonField:SetSize(250,nil)
    TICKET_PANEL.ReasonField:SetSortItems(false)
    TICKET_PANEL.ReasonField.hint = "Ticket Reason"

    TICKET_PANEL.ReasonField:AddChoice("Freekill/Freeshoot")
    TICKET_PANEL.ReasonField:AddChoice("NoRP/NoFearRP")
    TICKET_PANEL.ReasonField:AddChoice("PropsBlock/PropsClimb")
    TICKET_PANEL.ReasonField:AddChoice("NLR ( New Life Rule)")
    TICKET_PANEL.ReasonField:AddChoice("Heavy Insultes")
    TICKET_PANEL.ReasonField:AddChoice("Technical Question")
    TICKET_PANEL.ReasonField:AddChoice("Other (not listed) ")

    TICKET_PANEL.ReasonField.Paint = function(self, width, height) drawEntry(self, width, height, 5, TICKET_PANEL.ReasonField) end
end

function TICKET_PANEL.DrawEntry() 
    TICKET_PANEL.TitleField = vgui.Create("DTextEntry", TICKET_PANEL.Frame)
    TICKET_PANEL.TitleField:SetPos((PANEL_WIDTH*0.1)/2, PANEL_HEIGHT - (PANEL_HEIGHT*0.66))
    TICKET_PANEL.TitleField:SetSize(250,nil)
    TICKET_PANEL.TitleField.hint = "Ticket Title (max: 39)"

    TICKET_PANEL.TitleField.OnLoseFocus = function(self) self.focus = false end
    TICKET_PANEL.TitleField.OnGetFocus = function(self) focusEntry(self, TICKET_PANEL.TitleField) end
    TICKET_PANEL.TitleField.Paint = function(self, width, height) drawEntry(self, width, height, height/7, TICKET_PANEL.TitleField) end

    TICKET_PANEL.SteamField = vgui.Create("DTextEntry", TICKET_PANEL.Frame)
    TICKET_PANEL.SteamField:SetPos((PANEL_WIDTH*0.1)/2, PANEL_HEIGHT - (PANEL_HEIGHT*0.52))
    TICKET_PANEL.SteamField:SetSize(250,nil)
    TICKET_PANEL.SteamField.hint = "Player's SteamID (max: 17)"

    TICKET_PANEL.SteamField.OnLoseFocus = function(self) self.focus = false end
    TICKET_PANEL.SteamField.OnGetFocus = function(self) focusEntry(self, TICKET_PANEL.SteamField) end
    TICKET_PANEL.SteamField.Paint = function(self, width, height) drawEntry(self, width, height, height/7, TICKET_PANEL.SteamField) end

    TICKET_PANEL.InfoField = vgui.Create("DTextEntry", TICKET_PANEL.Frame)
    TICKET_PANEL.InfoField:SetPos((PANEL_WIDTH*0.8)/2, PANEL_HEIGHT - (PANEL_HEIGHT*0.66))
    TICKET_PANEL.InfoField:SetSize(420,nil)
    TICKET_PANEL.InfoField:SetMultiline(true)
    TICKET_PANEL.InfoField.hint = "Ticket Explanations (max: 355)"

    TICKET_PANEL.InfoField.OnLoseFocus = function(self) self.focus = false end
    TICKET_PANEL.InfoField.OnGetFocus = function(self) focusEntry(self, TICKET_PANEL.InfoField) end
    TICKET_PANEL.InfoField.Paint = function(self, width, height) drawEntry(self, width, height, 5, TICKET_PANEL.InfoField) end
end

function TICKET_PANEL.DrawFrame()
    TICKET_PANEL.Frame.Paint = function(self, width, height)
        surface.SetDrawColor(SPANEL_ADDON_THEME.background)
        surface.DrawRect(0, 0, width, height)

        surface.SetDrawColor(SPANEL_ADDON_THEME.main)
        surface.DrawRect(0, 0, width, height/13)

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
    TICKET_PANEL.DrawCombo()

    TICKET_PANEL.DisplayFrameButtons()

    TICKET_PANEL.HandleFrameAnimation(PANEL_WIDTH, PANEL_HEIGHT, TICKET_PANEL.Frame)
    TICKET_PANEL.HandleFrameResize(height, TICKET_PANEL.Frame)
    TICKET_PANEL.HandleFrameKeys(TICKET_PANEL.Frame)

    TICKET_PANEL.Frame.OnClose = function()
        if(keyPressed) then return end
        if(not LocalPlayer():GetNWBool("ticketInProgress")) then return end
        TICKET_PANEL.ClosePanel()
    end
end