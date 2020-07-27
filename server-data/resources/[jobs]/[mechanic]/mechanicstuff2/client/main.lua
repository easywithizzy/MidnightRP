ESX = nil

local PlayerData = {}

-- For ESX to work
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

-- Sets mainMenu to nil to help fix a few errors
local mainMenu = nil

-- Creates main vehicle menu
local mainMenu = RageUI.CreateMenu("~b~Vehicles", "All your needed tools")

-- Makes a config for spawner and deleter
evasion_Configout = {
    
    Positions = {
        
        {x = -197.3634, y = -1307.2509, z = 30.40}
    },
   
    Del = {
        
        {x = -183.6092, y = -1317.1719, z = 30.40}

    }
}


RageUI.CreateWhile(5.0, function()
    RageUI.IsVisible(mainMenu, true, true, true, function()
        
        RageUI.Button('Flat Bed', "Go get to that call", {
            LeftBadge = nil,
            RightBadge = nil,
            RightLabel = ""
        }, true, function(Hovered, Active, Selected)
            
            if Selected then
                
                spawnCar('flatbed')
                ESX.ShowNotification("~g~Your vehicle has been released")
            
            end
        end)
        
        RageUI.Button('Tow Truck', "Go get to that call", {
            LeftBadge = nil,
            RightBadge = nil,
            RightLabel = ""
        }, true, function(Hovered, Active, Selected)
            
            if Selected then
                
                spawnCar('towtruck')
                ESX.ShowNotification("~g~Your vehicle has been released")
            
            end
        end)
    end)
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        if PlayerData.job ~= nil and PlayerData.job.name == 'mechanic' then  

		    for k, v in pairs(evasion_Configout.Positions) do
			    local distance = GetDistanceBetweenCoords(playerCoords, v.x, v.y, v.z, true)

                if distance < 25.0 then
                    actualZone = v

                    zoneDistance = GetDistanceBetweenCoords(playerCoords, actualZone.x, actualZone.y, actualZone.z, true)

				    DrawMarker(1, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 1.0, 255, 255, 255, 100, false, true, 2, false, nil, nil, false)
                end
            
                if distance <= 1.5 then
                    ESX.ShowHelpNotification(_U('open_menuveh'))

                    if IsControlJustPressed(1, 51) then
                        RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))
                    end
                end

                if zoneDistance ~= nil then
                    if zoneDistance > 1.5 then
                        RageUI.CloseAll()
                    end
                end
            end
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        if PlayerData.job ~= nil and PlayerData.job.name == 'mechanic' then  

		    for k, v in pairs(evasion_Configout.Del) do
			    local distance = GetDistanceBetweenCoords(playerCoords, v.x, v.y, v.z, true)

                if distance < 15.0 then
                    actualZone = v

                    zoneDistance = GetDistanceBetweenCoords(playerCoords, actualZone.x, actualZone.y, actualZone.z, true)

				    DrawMarker(1, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 7.0, 7.0, 1.0, 255, 255, 255, 100, false, true, 2, false, nil, nil, false)
                end
            
                if distance <= 1.5 then
                    ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ to store vehicle')

                    if IsControlJustPressed(1, 51) then
                        vehicles = ESX.Game.GetVehiclesInArea(playerCoords, 7.0)
                        if #vehicles > 0 then
                            for k,v in ipairs(vehicles) do
                                ESX.Game.DeleteVehicle(v)
                                ESX.ShowNotification("~r~Vehicle Stored")
                            end
                        end
                    end
                end
            end
        end

        if zoneDistance ~= nil then
            if zoneDistance > 1.5 then
                 RageUI.CloseAll()
            end
		end
	end
end)


spawnCar = function(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end

    local vehicle = CreateVehicle(car, -162.5645, -1305.2730, 30.60, 90.89, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
end