TICKET_LIST = {}

function TICKET_LIST.queryTicket(title, steamid, reason, info, ply)

end

util.AddNetworkString("SP_NET_CL_REGISTER_TICKET")
local function registerTicket(title, steamid, reason, info, ply)
    net.Start("SP_NET_CL_REGISTER_TICKET")
        net.WriteString(title)
        net.WriteString(steamid)
        net.WriteString(reason)
        net.WriteString(info)
    net.Send(ply)
end

util.AddNetworkString("SP_NET_SV_REGISTER_TICKET")
net.Receive("SP_NET_SV_REGISTER_TICKET", function(len, ply)
    if not ply:IsValid() then return end
    local title = net.ReadString()
    local steamid = net.ReadString()
    local reason = net.ReadString()
    local info = net.ReadString()

    registerTicket(title, steamid, reason, info, ply)
end)