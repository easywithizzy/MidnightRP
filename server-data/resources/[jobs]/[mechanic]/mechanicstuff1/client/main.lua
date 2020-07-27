ESX = nil

local PlayerData = {}

local mainMenu = nil

-- For ESX to work
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

-- MAKES CLOAKROOM AND STOP MOUSE MOVEMENT
local mainMenu = RageUI.CreateMenu("~b~Cloakroom", 'Go get some work done')

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        RageUI.IsVisible(mainMenu, true, true, true, function()

            RageUI.Button("Employment: ".. ESX.PlayerData.job.label .. ' - ' .. ESX.PlayerData.job.grade_label .. '', " ", {
                LeftBadge = nil,
                RightBadge = nil,
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                end
            end)
            RageUI.Button("_____________________________",  "", {
                LeftBadge = nil,
                RightBadge = nil,
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                end
            end)
            RageUI.Button("~g~Start Shift",  "Let's start off today with a bang", {
                LeftBadge = nil,
                RightBadge = nil,
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                        if skin.sex == 0  then
                            TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
                            RageUI.CloseAll()
                            ESX.ShowNotification("You have clocked in")
                        else
                            TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
                            RageUI.CloseAll()
                            ESX.ShowNotification("You have clocked in")
                        end
                    end)
                end
            end)
            RageUI.Button("~r~End Shift",  "Take the day off", {
                LeftBadge = nil,
                RightBadge = nil,
                RightLabel = ""
            }, true, function(Hovered, Active, Selected)
                if Selected then
                    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                        TriggerEvent('skinchanger:loadSkin', skin)
                        RageUI.CloseAll()
                        ESX.ShowNotification("You have clocked out")
                    end)
                end
            end)
        end)
    end
end)

evasion_Config2 = {
    Positions = {
        {x = -212.1909, y = -1340.6514, z = 34.00}
    }
}

Citizen.CreateThread(function(source)
	while true do
		Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())

        if PlayerData.job ~= nil and PlayerData.job.name == 'mechanic' then  
		    for k, v in pairs(evasion_Config2.Positions) do
			    local distance = GetDistanceBetweenCoords(playerCoords, v.x, v.y, v.z, true)

                if distance < 10.0 then
                    actualZone = v

                    zoneDistance = GetDistanceBetweenCoords(playerCoords, actualZone.x, actualZone.y, actualZone.z, true)

				    DrawMarker(1, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 1.0, 255, 255, 255, 100, false, true, 2, false, nil, nil, false)
                end
            
                if distance <= 1.5 then
                    ESX.ShowHelpNotification(_U('open_menu'))

                    if IsControlJustPressed(1, 51) then
                        RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))
                    end
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