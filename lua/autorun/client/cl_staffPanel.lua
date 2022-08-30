include("autorun/sh_staffPanel.lua")

function HOTANIMATIONS.OpenMenu()
    local screenWidth, screenHeight = ScrW(), ScrH()
    local hudWidth, hudHeight = screenWidth*.25, screenHeight*.25
    local animTime, animeDelay, animeEase = 1, 0, 0.1

    if IsValid(HOTANIMATIONS.Menu) then
        HOTANIMATIONS.Menu:Remove()
    end

    HOTANIMATIONS.Menu = vgui.Create("DFrame")
    HOTANIMATIONS.Menu:SetTitle("StaffPanel - Manager")
    HOTANIMATIONS.Menu:MakePopup(true)
    HOTANIMATIONS.Menu:SetSize(0, 0)
    HOTANIMATIONS.Menu:Center()

    HOTANIMATIONS.Menu.Paint = function(me, width, height)
        surface.SetDrawColor(52,52,52,255)
        surface.DrawRect(0, 0, width, height)

        surface.SetDrawColor(210,144,52,255)
        surface.DrawRect(0, 0, width, height/11)
    end

    local isAnimating = true;
    HOTANIMATIONS.Menu:SizeTo(hudWidth, hudHeight, animTime, animDelay, animEase, function() 
        isAnimating = false 
    end)

    HOTANIMATIONS.Menu.Think = function(me) 
        if isAnimating then
            me:Center()
        end
    end
end

concommand.Add("openStaffPanel", HOTANIMATIONS.OpenMenu)