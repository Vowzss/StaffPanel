TICKET_LIST = {}

util.AddNetworkString("SP_NET_SV_REGISTER_TICKET")
net.Receive("SP_NET_SV_REGISTER_TICKET", function(len, ply)
    if not ply:IsValid() then return end
    local title = net.ReadString()
    local steam = net.ReadString()
    local reason = net.ReadString()
    local info = net.ReadString()

    print(title)
    print(steam)
    print(reason)
    print(info)
end)