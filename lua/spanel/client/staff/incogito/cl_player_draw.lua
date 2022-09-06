hook.Add("PrePlayerDraw", "SP_HK_PLAYER_DRAW", function(ply)
    if (ply:GetNWBool("SP_NW_SMODE_ENABLED") and ply:GetNWBool("SP_NW_VISIBLE")) then
        ply:DrawShadow(false)
        ply:SetMaterial("models/effects/vol_light001")
        ply:SetRenderMode(RENDERMODE_TRANSALPHA)
        return true
    else
        ply:DrawShadow(true)
        ply:SetMaterial("")
        ply:SetRenderMode(RENDERMODE_NORMAL)
        return false 
    end
end)