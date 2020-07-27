ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

MRV_Shops_Config = {
    Positions = {
		{x = -1231.3907,   y = -1480.7568,  z = 3.300}
	},
	
    Items = {
        {Label = 'Parachute', Value = 'gadget_parachute', Price = 150},
        {Label = 'Baseball Bat', Value = 'weapon_bat', Price = 50},
        {Label = 'Pool Cue', Value = 'weapon_poolcue', Price = 20},
        {Label = 'Golf Club', Value = 'weapon_golfclub', Price = 40}
    }
}

Citizen.CreateThread(function()
	for k, v in pairs(MRV_Shops_Config.Positions) do
		local blip = AddBlipForCoord(v.x, v.y, v.z)

		SetBlipSprite(blip, 94)
		SetBlipScale (blip, 0.8)
		SetBlipColour(blip, 0)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Sports Shop')
		EndTextCommandSetBlipName(blip)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())

		for k, v in pairs(MRV_Shops_Config.Positions) do
			local distance = GetDistanceBetweenCoords(playerCoords, v.x, v.y, v.z, true)

            if distance < 10.0 then
                actualZone = v

                zoneDistance = GetDistanceBetweenCoords(playerCoords, actualZone.x, actualZone.y, actualZone.z, true)

				DrawMarker(-1, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 100, false, true, 2, false, nil, nil, false)
            end
            
            if distance <= 1.5 then
                ESX.ShowHelpNotification(_U('open_menu'))

                if IsControlJustPressed(1, 51) then
                    RageUI.Visible(RMenu:Get('showcase', 'shopMenu'), not RageUI.Visible(RMenu:Get('showcase', 'shopMenu')))
                end
            end

            if zoneDistance ~= nil then
                if zoneDistance > 1.5 then
                    RageUI.CloseAll()
                end
            end
		end
	end
end)

local max = 10 -- number of items that can be selected
Numbers = {}

Citizen.CreateThread(function()
    for i = 1, max do
        table.insert(Numbers, i)
    end
end)