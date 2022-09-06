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

local function toggleWeapons(ply, toggle)
    if(toggle) then
        local weapons = ply:GetWeapons()
        for _, value in pairs(weapons) do
            print(value)
        end
    else
        local weapons = ply:GetWeapons()
        for _, value in pairs(weapons) do
            print(value)
        end
    end
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
            ply:SetNWBool("SP_NW_VISIBLE", true)
        end
    else
        if(not ply:GetNWBool("SP_NW_VISIBLE")) then 
            log = "  - Invisibility already [OFF]!"
        else 
            log = "  - Invisibility turned [OFF]!"
            ply:SetNWBool("SP_NW_VISIBLE", false)
        end
    end
    return log
end

util.AddNetworkString("SP_NET_CL_SMODE_ACTIVE")
local function toggleSMode(ply, toggle)
    ply:SetNWBool("SP_NW_SMODE_ACTIVE", toggle)

    local loggedMessages = {}
    table.insert(loggedMessages, "SMode turned [" .. (toggle and "ON" or "OFF") .. "]!")
    table.insert(loggedMessages, toggleGodMode(ply, toggle))
    table.insert(loggedMessages, toggleNoClip(ply, toggle))
    table.insert(loggedMessages, toggleInvisibility(ply, toggle))

    toggleWeapons(ply, not toggle)

    net.Start("SP_NET_CL_SMODE_ACTIVE")
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

    toggleSMode(ply, isActive)
end)