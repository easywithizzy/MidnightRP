ESX = nil

local isProcessing = false


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
    end
end)

evasion_config = {

    loc = {
        
        {x = -581.23, y = -778.68, z = 24.05} -- LSD PICK

    }
}

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(0)

        local playerCoords = GetEntityCoords(PlayerPedId())

        for k, v in pairs(evasion_config.loc) do
            local distance = GetDistanceBetweenCoords(playerCoords, v.x, v.y, v.z, true)

            if distance < 15.0 then
                actualZone = v

                zoneDistance = GetDistanceBetweenCoords(playerCoords, actualZone.x, actualZone.y, actualZone.z, true)

                DrawMarker(1, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 0.5, 255, 255, 255, 100, false, true, 2, false, nil, nil, false)
            end
        
            if distance <= 1.5 then
                ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ to begin picking')

                if IsControlJustPressed(1, 51) then
                    ProcessLSD()
                end
            end
        end
    end
end)

function ProcessLSD()
    
    isProcessing = true

	TriggerServerEvent('encore_drugs:lsd')
	local timeLeft = 1000 * 10 / 1000
	local playerPed = PlayerPedId()

	while timeLeft > 0 do
		Citizen.Wait(1000)
		timeLeft = timeLeft - 1
    end
    
	isProcessing = false
end