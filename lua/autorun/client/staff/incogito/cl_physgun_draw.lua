hook.Add("DrawPhysgunBeam", "SP_HK_PHYS_BEAM_DRAW", function( ply)
    if (ply:GetNWBool("SP_NW_SMODE_ENABLED") and ply:GetNWBool("SP_NW_VISIBLE")) then
        return false  
    else
        return true 
    end
end)