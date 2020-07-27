-- Announcing
TriggerEvent('es:addGroupCommand', 'announcement', "admin", function(source, args, user)
	TriggerClientEvent('announcement', -1, "~r~announcement", table.concat(args, " "), 5)
end, function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "Insufficienct permissions!")
end, {help = "Announce a message to the entire server", params = {{name = "announcement", help = "The message to announce"}}})
