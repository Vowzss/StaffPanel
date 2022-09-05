local function toggleNoClip(ply, toggle)
    local log
    if (toggle) then 
        if(ply:GetMoveType() == MOVETYPE_NOCLIP) then
            log = "  - NoClip mode already [ON]!"
        else
            log = "  - NoClip mode turned [ON]!"
            ply:SetNWBool("SP_NW_NOCLIP", false)
            ply:SetMoveType(MOVETYPE_NOCLIP)
        end
    else
        if(ply:GetMoveType() != MOVETYPE_NOCLIP) then
            log = "  - NoClip mode already [OFF]!"
        else
            log = "  - NoClip mode turned [OFF]!"
            ply:SetNWBool("SP_NW_NOCLIP", false)
            ply:SetMoveType(MOVETYPE_WALK)
        end
    end
    return log
end

local function toggleGodMode(ply, toggle)
    local log
    if(toggle) then
        if(ply:HasGodMode()) then 
            log = "  - God mode already [ON]!"
        else 
            log = "  - God mode turned [ON]!"
            ply:SetNWBool("SP_NW_GOD", true)
            ply:GodEnable()
        end
    else
        if(not ply:HasGodMode()) then 
            log = "  - God mode already [OFF]!"
        else 
            log = "  - God mode turned [OFF]!"
            ply:SetNWBool("SP_NW_GOD", false)
            ply:GodDisable()
        end
    end
    return log
end

local function toggleInvisibility(ply, toggle)
    local log
    if(toggle) then
        if(ply:GetNWBool("SP_NW_VISIBLE")) then
            log = "  - Invisibility already [ON]!"
        else 
            log = "  - Invisibility turned [ON]!"
            ply:SetNWBool("SP_NW_VISIBLE", true )
        end
    else
        if(ply:GetNWBool("SP_NW_VISIBLE")) then 
            log = "  - Invisibility already [OFF]!"
        else 
            log = "  - Invisibility turned [OFF]!"
            ply:SetNWBool("SP_NW_VISIBLE", false )
        end
    end
    return log
end

util.AddNetworkString("SP_NET_CL_SMODE_ENABLED")
local function toggleSMode(ply)
    ply:SetNWBool("SP_NW_SMODE_ENABLED", true)

    local loggedMessages = {}
    table.insert(loggedMessages, "SMode turned [ON]!")
    table.insert(loggedMessages, toggleGodMode(ply, true))
    table.insert(loggedMessages, toggleNoClip(ply, true))
    table.insert(loggedMessages, toggleInvisibility(ply, true))

    net.Start("SP_NET_CL_SMODE_ENABLED")
        net.WriteUInt(#loggedMessages, 8)
        for _, msg in ipairs(loggedMessages) do
            net.WriteString(msg)
        end
    net.Send(ply)
end

util.AddNetworkString("SP_NET_CL_S_DISABLED")
local function unToggleSMode(ply)
    ply:SetNWBool("SP_NW_SMODE_ENABLED", false)

    local loggedMessages = {}
    table.insert(loggedMessages, "SMode turned [OFF]!")
    table.insert(loggedMessages, toggleGodMode(ply, false))
    table.insert(loggedMessages, toggleNoClip(ply, false))
    table.insert(loggedMessages, toggleInvisibility(ply, false ))

    net.Start("SP_NET_CL_S_DISABLED")
        net.WriteUInt(#loggedMessages, 8)
        for _, msg in ipairs(loggedMessages) do
            net.WriteString(msg)
        end
    net.Send(ply)
end

util.AddNetworkString("SP_NET_SV_TURN_SMODE")
net.Receive("SP_NET_SV_TURN_SMODE", function(len, ply)
    if not ply:IsValid() then return end
    local isActive = net.ReadBool()

    if(isActive) then 
        toggleSMode(ply)
    else 
        unToggleSMode(ply)
    end
end)