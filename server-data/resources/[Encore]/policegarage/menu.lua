_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("~b~LSPD","Garage full of wonders")
_menuPool:Add(mainMenu)
_menuPool:MouseControlsEnabled(false)
_menuPool:ControlDisablingEnabled(false)

ESX = nil
local PlayerData = {}
local playerPed = PlayerPedId()

evasion_Config = {
    
    Positions = {

        {x = 458.773, y = -1008.2780, z = 27.30}

    },

    del = {
        {x = 454.5140, y = -1017.3439, z = 27.30}
    }
}

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


AddCarMenu = function(menu)
    local carsubmenu = _menuPool:AddSubMenu(menu,"Vehicles","~w~Your list of your toys")
    _menuPool:ProcessMenus()
    _menuPool:MouseEdgeEnabled (false);
    for _, vehicles in pairs(Config.Vehicles) do
        local vehicleItem = NativeUI.CreateItem(vehicles.Label, "")
        carsubmenu.SubMenu:AddItem(vehicleItem)

        carsubmenu.SubMenu.OnItemSelect = function(_, _, index)
            spawnCar(Config.Vehicles[index].Hash)
            notify("~g~Your vehicle has been released")
        end
    end
end


AddCarMenu(mainMenu)
_menuPool:RefreshIndex()


function notify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, true)
end


Citizen.CreateThread(function()
    while true do
        Wait(0)
        _menuPool:ProcessMenus()
        _menuPool:MouseEdgeEnabled (false);

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            if IsEntityAtCoord(PlayerPedId(), 459.21, -1008.07, 28.26, 1.5, 1.5, 1.5, 0, 1, 0) then 

                    if PlayerData.job ~= nil and PlayerData.job.name == 'police' then    
                        ESX.ShowHelpNotification("Press ~INPUT_TALK~ to access the garage")
                        if IsControlJustPressed(1,51) then
                            mainMenu:Visible(not mainMenu:Visible())
                        end
                    end
                end    
            end
        end)
        
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if PlayerData.job ~= nil and PlayerData.job.name == 'police' then  
            local playerCoords = GetEntityCoords(PlayerPedId())
        
            for k, v in pairs(evasion_Config.Positions) do
                local distance = GetDistanceBetweenCoords(playerCoords, v.x, v.y, v.z, true)
        
                if distance < 20.0 then
                    actualZone = v
        
                    zoneDistance = GetDistanceBetweenCoords(playerCoords, actualZone.x, actualZone.y, actualZone.z, true)
        
                    DrawMarker(1, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 100, false, true, 2, false, nil, nil, false)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
        if PlayerData.job ~= nil and PlayerData.job.name == 'police' then  
            local playerCoords = GetEntityCoords(PlayerPedId())

		    for k, v in pairs(evasion_Config.del) do
			    local distance = GetDistanceBetweenCoords(playerCoords, v.x, v.y, v.z, true)

                if distance < 15.0 then
                    actualZone = v

                    zoneDistance = GetDistanceBetweenCoords(playerCoords, actualZone.x, actualZone.y, actualZone.z, true)

				    DrawMarker(1, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 5.0, 1.0, 255, 255, 255, 100, false, true, 2, false, nil, nil, false)
                end
            
                if distance <= 1.5 then
                    ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ to store vehicle')

                    if IsControlJustPressed(1, 51) then
                        vehicles = ESX.Game.GetVehiclesInArea(playerCoords, 2.0)
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
    end
end)

spawnCar = function(car)
    local car = GetHashKey(car)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end

    local vehicle = CreateVehicle(car, 446.1787, -1025.0614, 27.60, 356.6852, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
end