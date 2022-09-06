closeKeyPressed = false
local prevTime = 0

function keyHandler(keyCode)
    closeKeyPressed = false
    if (keyCode == KEY_O and UnPredictedCurTime() > prevTime + 0.05) then
        closeKeyPressed = true
        prevTime = UnPredictedCurTime()

        if(STAFF_PANEL.IsPanelOpenned()) then
            STAFF_PANEL.ClosePanel()
        else
            STAFF_PANEL.OpenPanel()
        end
    end
end

hook.Add("PlayerButtonDown", "SP_HK_BUTTON_DOWN", function(ply, keyCode)
    if(IsFirstTimePredicted()) then
	    keyHandler(keyCode)
    end
end)