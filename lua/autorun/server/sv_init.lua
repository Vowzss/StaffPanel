include("autorun/sh_init.lua")

print()
print("------------------------------------")
print("---------    " .. ADDON_CONFIG.name .. "    ---------")
print("-------    " .. ADDON_CONFIG.author .. "    -------")
print("------------------------------------")
print()

print("Successfully loaded " .. ADDON_CONFIG.name .. " ver: " .. ADDON_CONFIG.version)

util.AddNetworkString("SP_NET_CL_StaffModeOn")
local function toggleStaffMode(ply)
    ply.staffModeEnabled = true
    local loggedMessages = {}
    table.insert(loggedMessages, "Staff mode turned ON!")
    if (ply:HasGodMode()) then 
        table.insert(loggedMessages, "  - God mode already ON!")
    else
        table.insert(loggedMessages, "  - God mode turned ON!")
        ply:GodEnable()
    end

    net.Start("SP_NET_CL_StaffModeOn")
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
    table.insert(loggedMessages, "Staff mode turned OFF!")
    if (not ply:HasGodMode()) then 
        table.insert(loggedMessages, "  - God mode already OFF!")
    else
        table.insert(loggedMessages, "  - God mode turned OFF!")
        ply:GodDisable()
    end

    net.Start("SP_NET_CL_StaffModeOff")
        net.WriteUInt(#loggedMessages, 8)
        for _, msg in ipairs(loggedMessages) do
            net.WriteString(msg)
        end
    net.Send(ply)
end

local function toggleGodMode(ply, toggle)
    if(toggle and not ply:HasGodMode()) then
        ply:GodEnable()
    end

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