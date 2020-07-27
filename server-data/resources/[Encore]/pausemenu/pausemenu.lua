function AddTextEntry(key, value)
	Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end

Citizen.CreateThread(function()
	AddTextEntry('FE_THDR_GTAO', "~y~Encore RP~w~ | Discord : https://discord.gg/7P75Trr")
end)

