ESX = nil

local PlayerData = {}
local vehicle = nil

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


-- Creates main action menu
local mainMenu = RageUI.CreateMenu("~b~Actions", "This might come in handy")

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if RageUI.Visible(mainMenu) then
            RageUI.DrawContent({ header = true, instructionalButton = true }, function()
                RageUI.Button('Repair Vehicle', "Tools...", {
                    LeftBadge = nil,
                    RightBadge = nil,
                    RightLabel = nil
                }, true, function(Hovered, Active, Selected)
                    if Selected then
                        local playerPed		= GetPlayerPed(-1)
                        local coords		= GetEntityCoords(playerPed)
                    
                        if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
                            local vehicle = nil
                            TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_BUM_BIN", 0, true)

			                Citizen.CreateThread(function()
				                ThreadID = GetIdOfThisThread()
				                CurrentAction = 'repair'

				                Citizen.Wait(15000)

				                if CurrentAction ~= nil then
                                    Citizen.Wait(15000)
                                    SetVehicleFixed(vehicle)
					                SetVehicleDeformationFixed(vehicle)
					                SetVehicleUndriveable(vehicle, false)
					                SetVehicleEngineOn(vehicle, true, true)
					                ClearPedTasksImmediately(playerPed)

					                ESX.ShowNotification(_U('finished_repair'))
				                end
                            end)
                        end
                    end
                end)
                RageUI.Button('Lockpick', "Tools...", {
                    LeftBadge = nil,
                    RightBadge = nil,
                    RightLabel = nil
                }, true, function(Hovered, Active, Selected) 
                    if Selected then
                        local playerPed	= GetPlayerPed(-1)
                        local coords = GetEntityCoords(playerPed)
                        if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
                            TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
                            Citizen.Wait(20000)
                            ClearPedTasksImmediately(playerPed)
                            
                            SetVehicleDoorsLocked(vehicle, 1)
                            SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                            ESX.ShowNotification("The vehicle has been ~g~unlocked")
                        end
                    end
                end)
                RageUI.Button('Impound', "Tools...", {
                    LeftBadge = nil,
                    RightBadge = nil,
                    RightLabel = nil
                }, true, function(Hovered, Active, Selected) 
                    if Selected then
                        local playerPed	= GetPlayerPed(-1)
                        local playerCoords = GetEntityCoords(PlayerPedId())
                        vehicles = ESX.Game.GetVehiclesInArea(playerCoords, 3.0)
                        for k,v in ipairs(vehicles) do
                            if IsAnyVehicleNearPoint(playerCoords.x, playerCoords.y, playerCoords.z, 3.0) then
                                TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
                                Citizen.Wait(10000)
                                ClearPedTasksImmediately(playerPed)
                                ESX.Game.DeleteVehicle(v)
                                ESX.ShowNotification("The vehicle has been ~b~Impounded")
                            end
                        end
                    end
                end)
                RageUI.Button('Invoice', "Tools...", {
                    LeftBadge = nil,
                    RightBadge = nil,
                    RightLabel = nil
                }, true, function(Hovered, Active, Selected) 
                    if Selected then
                        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
                            title = ('Amount')
                        }, function(data, menu)
                            local amount = tonumber(data.value)
        
                            if amount == nil or amount < 0 then
                                ESX.ShowNotification("Invalid Amount!")
                            else
                                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            
                                if closestPlayer == -1 or closestDistance > 3.0 then
                                    ESX.ShowNotification("No players nearby")
                                    menu.close()
                                else
                                    TriggerServerEvent('esx_billing:sendBill1', GetPlayerServerId(closestPlayer), 'society_mechanic', 'billing', amount)
                                    menu.close()
                                end
                            end
                        end)
                    end
                end)
            end)
        end
    end
end)
    
Citizen.CreateThread(function()
	while true do
        Citizen.Wait(0)			
        if PlayerData.job and PlayerData.job.name == 'mechanic' then
            if IsControlJustPressed(1, 167) then
                RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))
            end
        end
	end
end)