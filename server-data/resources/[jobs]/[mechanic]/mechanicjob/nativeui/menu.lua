_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("~b~LSPD","Garage full of wonders")
_menuPool:Add(mainMenu)
_menuPool:MouseControlsEnabled(false)
_menuPool:ControlDisablingEnabled(false)

ESX = nil
local PlayerData = {}

evasion_Config = {
    
    Positions = {

        {x = -212.1909, y = -1340.6514, z = 34.00}

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

VehDel = function(menu)
    local delcar = NativeUI.CreateItem("Delete nearest vehicle", "Slap her back in the garage")
    local playerCoords = GetEntityCoords(PlayerPedId())
    menu:AddItem(delcar)
    menu.OnItemSelect = function(sender, item, index)
        if item == delcar then
            vehicles = ESX.Game.GetVehiclesInArea(playerCoords, 16.0)
            if #vehicles > 0 then
                for k,v in ipairs(vehicles) do
                    ESX.Game.DeleteVehicle(v)
                    notify("~r~Vehicle has been returned to the garage")
                    break
                end
            end
        end
    end
end

VehDel(mainMenu)
_menuPool:RefreshIndex()


function notify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, true)
end


Citizen.CreateThread(function()
    local playerPed = PlayerPedId()
    while true do
        Wait(0)
        _menuPool:ProcessMenus()
        _menuPool:MouseEdgeEnabled (false);

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            if IsEntityAtCoord(PlayerPedId(), -212.1909,  -1340.6514,  34.00, 1.5, 1.5, 1.5, 0, 1, 0) then 

                    if PlayerData.job ~= nil and PlayerData.job.name == 'mechanic' then    
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
        if PlayerData.job ~= nil and PlayerData.job.name == 'mechanic' then  
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