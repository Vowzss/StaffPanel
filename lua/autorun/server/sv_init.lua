include("autorun/sh_init.lua")

print()
print("------------------------------------")
print("---------    " .. ADDON_CONFIG.name .. "    ---------")
print("-------    " .. ADDON_CONFIG.author .. "    -------")
print("------------------------------------")
print()

print("Successfully loaded " .. ADDON_CONFIG.name .. " ver: " .. ADDON_CONFIG.version)

local staffModeEnabled = false

function toggleStaffMode(ply)
    if (ply:HasGodMode()) then return end

    staffModeEnabled = true
    ply:GodEnable()

    net.Start("SP_NET_CL_StaffModeOn")
    net.WriteString("Staff mode turned ON!")
    net.WriteColor(Color(0,255,0))
    net.SendToServer()
end

function unToggleStaffMode(ply)
    if (not ply:HasGodMode()) then return end

    staffModeEnabled = false
    ply:GodDisable()

    net.Start("SP_NET_CL_StaffModeOff")
    net.WriteString("Staff mode turned OFF!")
    net.WriteColor(Color(255,0,0))
    net.SendToServer()
end

util.AddNetworkString("SP_NET_CL_StaffModeOn")
util.AddNetworkString("SP_NET_CL_StaffModeOff")

util.AddNetworkString("SP_NET_SV_TurnStaffMode")
net.Receive("SP_NET_SV_TurnStaffMode", function(len, ply)
    local active = net.ReadBool()

    if (active) then 
        toggleStaffMode(ply)
    else 
        unToggleStaffMode(ply)
    end
end)