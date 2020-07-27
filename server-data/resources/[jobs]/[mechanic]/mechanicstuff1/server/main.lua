ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterServerEvent('encoremech:whitelist')
AddEventHandler('encoremech:whitelist', function(xPlayer, source)
	local whitelist = {}
	
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local identifier = xPlayer.identifier
	
	getPlayerData2(source, function(data)
		if data.tow > -1 then
			table.insert(whitelist, {
				job = 1
			})
		end
	end)
end)

function getPlayerData2(identifier, cb)
	-- Get Player Info
	local result = MySQL.Sync.fetchAll('SELECT `leo_rank`, `ems_rank`, `tow_rank` FROM users WHERE identifier = @identifier', {
		['@identifier'] = identifier
	})

	local leo = result[1].leo_rank
	local ems = result[1].ems_rank
	local tow = result[1].tow_rank

	local data = {
		leo = leo,
		ems = ems,
		tow = tow
	}

	cb(data)
end
