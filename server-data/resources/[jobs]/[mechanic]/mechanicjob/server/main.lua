ESX = nil
local Vehicles

local VehiclesInShop = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('fpwn_customs:refreshOwnedVehicle')
AddEventHandler('fpwn_customs:refreshOwnedVehicle', function(vehicleProps)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT vehicle FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = vehicleProps.plate
	}, function(result)
		if result[1] then
			local vehicle = json.decode(result[1].vehicle)

			if vehicleProps.model == vehicle.model then
				MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE plate = @plate', {
					['@plate'] = vehicleProps.plate,
					['@vehicle'] = json.encode(vehicleProps)
				})
			else
				print(('fpwn_customs: %s attempted to upgrade vehicle with mismatching vehicle model!'):format(xPlayer.identifier))
			end
		end
	end)
end)

ESX.RegisterServerCallback('fpwn_customs:getVehiclesPrices', function(source, cb)
	if not Vehicles then
		MySQL.Async.fetchAll('SELECT * FROM vehicles', {}, function(result)
			local vehicles = {}

			for i=1, #result, 1 do
				table.insert(vehicles, {
					model = result[i].model,
					price = result[i].price
				})
			end

			Vehicles = vehicles
			cb(Vehicles)
		end)
	else
		cb(Vehicles)
	end
end)

RegisterServerEvent('fpwn_customs:checkVehicle')
AddEventHandler('fpwn_customs:checkVehicle', function(plate)
	local xPlayer = ESX.GetPlayerFromId(source)
	--print("plate: " .. plate)
	for k, v in pairs(VehiclesInShop) do 
		--print("k: " .. k)
		--print("v['plate']: " .. v['plate'])
		if v.plate == plate and _source ~= k then
			--print("found it")
			TriggerClientEvent('fpwn_customs:resetVehicle', source, v)
			VehiclesInShop[xPlayer.identifier] = nil
			break
		end
	end
end)

RegisterServerEvent('fpwn_customs:saveVehicle')
AddEventHandler('fpwn_customs:saveVehicle', function(oldVehProps)
	local xPlayer = ESX.GetPlayerFromId(source)
	--print("oldVehProps['plate']: " .. oldVehProps['plate'])
	if oldVehProps then
		VehiclesInShop[xPlayer.identifier] = oldVehProps
		--print("VehiclesInShop[_source][plate]: " .. VehiclesInShop[_source]['plate'])
	end
end)

RegisterServerEvent('fpwn_customs:finishPurchase')
AddEventHandler('fpwn_customs:finishPurchase', function(society, newVehProps, shopCart, playerId, shopProfit, source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(playerId)
	local pid = playerId
	local isFinished = false
	local price, amount = calcFinalPrice(shopCart, shopProfit)

	TriggerEvent('fpwn_customs:refreshOwnedVehicle', newVehProps)
	TriggerEvent('fpwn_customs:saveVehicle', vehModsOld)
	isFinished = true
end)


ESX.RegisterServerCallback('encoremech:getwhitelist', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local result = MySQL.Sync.fetchAll('SELECT `leo_rank`, `ems_rank`, `tow_rank` FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
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
end)