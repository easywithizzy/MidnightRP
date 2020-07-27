ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
    end
end)

RegisterServerEvent('encore_drugs:lsd')
AddEventHandler('encore_drugs:lsd', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.canCarryItem('lsd', 1) then
		xPlayer.addInventoryItem('lsd', 1)
	else
		xPlayer.showNotification('Invenotry full!')
	end
end)
