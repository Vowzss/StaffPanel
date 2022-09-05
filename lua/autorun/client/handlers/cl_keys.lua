include("autorun/sh_init.lua")

local closeKeyPressed = false
local prevTime = 0

function keyHandler(keyCode)
    closeKeyPressed = false
    if (keyCode == KEY_O and UnPredictedCurTime() > prevTime + 0.05) then
        closeKeyPressed = true
        prevTime = UnPredictedCurTime()

        print(keyCode)
        /*if(isPanelOpenned) then
            STAFF_PANEL:CloseFrame()
        else
            STAFF_PANEL:OpenFrame()
        end*/
    end
end

hook.Add("PlayerButtonDown", "SP_HK_BUTTON_DOWN", function(ply, keyCode)
    if(IsFirstTimePredicted()) then
	    keyHandler(keyCode)
    end
end)