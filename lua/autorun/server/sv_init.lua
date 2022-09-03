include("autorun/sh_init.lua")

print()
print("------------------------------------")
print("---------    " .. ADDON_CONFIG.name .. "    ---------")
print("-------    " .. ADDON_CONFIG.author .. "    -------")
print("------------------------------------")
print()

print("Successfully loaded " .. ADDON_CONFIG.name .. " ver: " .. ADDON_CONFIG.version)

local function toggleNoClip(ply, toggle)
    local log
    if (toggle) then 
        if(ply:GetMoveType() == MOVETYPE_NOCLIP) then
            log = "  - NoClip mode already [ON]!"
        else
            log = "  - NoClip mode turned [ON]!"
            ply:SetMoveType(MOVETYPE_NOCLIP)
        end
    else
        if(ply:GetMoveType() != MOVETYPE_NOCLIP) then
            log = "  - NoClip mode already [OFF]!"
        else
            log = "  - NoClip mode turned [OFF]!"
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
            ply:GodEnable()
        end
    else
        if(not ply:HasGodMode()) then 
            log = "  - God mode already [OFF]!"
        else 
            log = "  - God mode turned [OFF]!"
            ply:GodDisable()
        end
    end
    return log
end

local function toggleVisibility(ply, toggle)
    local log
    if(toggle) then
        if(ply.isVisible) then 
            log = "  - Invisibility already [ON]!"
        else 
            log = "  - Invisibility turned [ON]!"
            ply.isVisible = true
        end
    else
        if(not ply.isVisible) then 
            log = "  - Invisibility already [OFF]!"
        else 
            log = "  - Invisibility turned [OFF]!"
            ply.isVisible = false
        end
    end
    return log
end

util.AddNetworkString("SP_NET_CL_StaffModeOn")
local function toggleStaffMode(ply)
    ply.staffModeEnabled = true
    local loggedMessages = {}
    table.insert(loggedMessages, "Staff mode turned [ON]!")
    table.insert(loggedMessages, toggleGodMode(ply, true))
    table.insert(loggedMessages, toggleNoClip(ply, true))
    table.insert(loggedMessages, toggleVisibility(ply, true))

    net.Start("SP_NET_CL_StaffModeOn")
        net.WriteBool(ply.staffModeEnabled)
        net.WriteUInt(#loggedMessages, 8)
        for _, msg in ipairs(loggedMessages) do
            net.WriteString(msg)
        end
    net.Send(ply)
end

util.AddNetworkString("SP_NET_CL_StaffModeOff")
local function unToggleStaffMode(ply)
    ply.staffModeEnabled = false
    local loggedMessages = {}
    table.insert(loggedMessages, "Staff mode turned [OFF]!")
    table.insert(loggedMessages, toggleGodMode(ply, false))
    table.insert(loggedMessages, toggleNoClip(ply, false))
    table.insert(loggedMessages, toggleVisibility(ply, false ))

    net.Start("SP_NET_CL_StaffModeOff")
        net.WriteBool(ply.staffModeEnabled)
        net.WriteUInt(#loggedMessages, 8)
        for _, msg in ipairs(loggedMessages) do
            net.WriteString(msg)
        end
    net.Send(ply)
end

util.AddNetworkString("SP_NET_SV_TurnStaffMode")
net.Receive("SP_NET_SV_TurnStaffMode", function(len, ply)
    if not ply:IsValid() then return end
    local isActive = net.ReadBool()

    if(isActive) then 
        toggleStaffMode(ply)
    else 
        unToggleStaffMode(ply)
    end
end)