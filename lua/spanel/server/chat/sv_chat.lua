hook.Add("OnPlayerChat", "SP_HK_PLAYER_CHAT", function( ply, text, teamChat, isDead) 
    if not ply:IsValid() then return end
	if(isDead) then ply:ChatPrint("You cannot send messages when you are dead!") return end

	text = string.lower( text )
	if (text == "/hello") then
		print( "Hello world!" )
		return true
	end
end)