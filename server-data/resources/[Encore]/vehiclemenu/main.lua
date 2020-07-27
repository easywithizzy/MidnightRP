local control = 244 -- sets control to M
local title = "~b~Vehicles"

_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu(title, "~b~Take control of yo vehicle") 
submenu = _menuPool:AddSubMenu(mainMenu, "Doors")
submenu1 = _menuPool:AddSubMenu(mainMenu, "Windows")
_menuPool:Add(mainMenu)
_menuPool:MouseControlsEnabled(false)
_menuPool:ControlDisablingEnabled(false)

function doorsub(menu)
    local frontleft = NativeUI.CreateItem("Front Left", "")
    local frontright = NativeUI.CreateItem("Front Right", "")
    local rearleft = NativeUI.CreateItem("Rear Left", "")
    local rearright = NativeUI.CreateItem("Rear Right", "")
    submenu:AddItem(frontleft)
    submenu:AddItem(frontright)
    submenu:AddItem(rearleft)
    submenu:AddItem(rearright)    
    submenu.OnItemSelect = function(sender, item, index)
        if item == frontleft then
            TriggerEvent('frontLeft')
        end
        if item == frontright then
            TriggerEvent('frontRight')
        end
        if item == rearleft then
            TriggerEvent('rearLeft')
        end
        if item == rearright then
            TriggerEvent('rearRight')
        end
    end
end

function windowsub(menu)
    local front = NativeUI.CreateItem("Front Windows", "")
    local rear = NativeUI.CreateItem("Rear Windows", "")
    submenu1:AddItem(front)
    submenu1:AddItem(rear) 
    submenu1.OnItemSelect = function(sender, item, index)
        if item == front then
            TriggerEvent('frontWindow')
        end
        if item == rear then
            TriggerEvent('rearWindow')
        end
    end
end


function Hoodengine(menu)
    local Item3 = NativeUI.CreateItem("Hood", "Pop that hood")
    local Item4 = NativeUI.CreateItem("Engine", "Shut her down")
    local Item5 = NativeUI.CreateItem("Trunk", "")
    menu:AddItem(Item3)
    menu:AddItem(Item4)
    menu:AddItem(Item5)
    menu.OnItemSelect = function(sender, item, index)
        if item == Item3 then
            TriggerEvent('openHood')
        end
        if item == Item4 then
            TriggerEvent('engine')
        end    
        if item == Item5 then
            TriggerEvent('openTrunk')
        end
    end
end

doorsub(mainMenu)
windowsub(mainMenu)
Hoodengine(mainMenu)
_menuPool:RefreshIndex()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        _menuPool:ProcessMenus()
        local ped = PlayerPedId()
        if IsControlJustPressed(1, control) and GetLastInputMethod( 0 ) and IsPedSittingInAnyVehicle(ped) then
            mainMenu:Visible(not mainMenu:Visible())
        end
    end
end)

function notify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, true)
end

local windowup = true
RegisterNetEvent("frontWindow")
AddEventHandler('frontWindow', function()
    local playerPed = GetPlayerPed(-1)
    if IsPedInAnyVehicle(playerPed, false) then
        local playerCar = GetVehiclePedIsIn(playerPed, false)
		if ( GetPedInVehicleSeat( playerCar, -1 ) == playerPed ) then 
            SetEntityAsMissionEntity( playerCar, true, true )
		
			if ( windowup ) then
				RollDownWindow(playerCar, 0)
				RollDownWindow(playerCar, 1)
				windowup = false
			else
				RollUpWindow(playerCar, 0)
				RollUpWindow(playerCar, 1)
				windowup = true
			end
		end
	end
end )

local windowup = true
RegisterNetEvent("rearWindow")
AddEventHandler('rearWindow', function()
    local playerPed = GetPlayerPed(-1)
    if IsPedInAnyVehicle(playerPed, false) then
        local playerCar = GetVehiclePedIsIn(playerPed, false)
		if ( GetPedInVehicleSeat( playerCar, -1 ) == playerPed ) then 
            SetEntityAsMissionEntity( playerCar, true, true )
            
            if ( windowup ) then
				RollDownWindow(playerCar, 2)
				RollDownWindow(playerCar, 3)
				windowup = false
			else
				RollUpWindow(playerCar, 2)
				RollUpWindow(playerCar, 3)
				windowup = true
			end
		end
	end
end )

--engine

IsEngineOn = true
RegisterNetEvent('engine')
AddEventHandler('engine',function() 
	local player = GetPlayerPed(-1)
	
	if (IsPedSittingInAnyVehicle(player)) then 
		local vehicle = GetVehiclePedIsIn(player,false)
		
		if IsEngineOn == true then
			IsEngineOn = false
			SetVehicleEngineOn(vehicle,false,false,false)
		else
			IsEngineOn = true
			SetVehicleUndriveable(vehicle,false)
			SetVehicleEngineOn(vehicle,true,false,false)
		end
		
		while (IsEngineOn == false) do
			SetVehicleUndriveable(vehicle,true)
			Citizen.Wait(0)
		end
	end
end )
--front left door open/close

RegisterNetEvent( 'frontLeft' )
AddEventHandler( 'frontLeft', function()

    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= nil and veh ~= 0 and veh ~= 1 then
        if GetVehicleDoorAngleRatio(veh, 0) > 0 then
            SetVehicleDoorShut(veh, 0, false)
        else
            SetVehicleDoorOpen(veh, 0, false, false)
        end
    end
end)

--front right door open/close

RegisterNetEvent( 'frontRight' )
AddEventHandler( 'frontRight', function()

    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= nil and veh ~= 0 and veh ~= 1 then
        if GetVehicleDoorAngleRatio(veh, 1) > 0 then
            SetVehicleDoorShut(veh, 1, false)
        else
            SetVehicleDoorOpen(veh, 1, false, false)
        end
    end
end)

-- back left door open/close

RegisterNetEvent( 'rearLeft' )
AddEventHandler( 'rearLeft', function()

    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= nil and veh ~= 0 and veh ~= 1 then
        if GetVehicleDoorAngleRatio(veh, 2) > 0 then
            SetVehicleDoorShut(veh, 2, false)
        else
            SetVehicleDoorOpen(veh, 2, false, false)
        end
    end
end)

-- back right door open/close

RegisterNetEvent( 'rearRight' )
AddEventHandler( 'rearRight', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= nil and veh ~= 0 and veh ~= 1 then
        if GetVehicleDoorAngleRatio(veh, 3) > 0 then
            SetVehicleDoorShut(veh, 3, false)
        else
            SetVehicleDoorOpen(veh, 3, false, false)
        end
    end
end)

--hood
RegisterNetEvent( 'openHood' )
AddEventHandler( 'openHood', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= nil and veh ~= 0 and veh ~= 1 then
        if GetVehicleDoorAngleRatio(veh, 4) > 0 then
            SetVehicleDoorShut(veh, 4, false)
        else
            SetVehicleDoorOpen(veh, 4, false, false)
        end
    end
end)

-- trunk
RegisterNetEvent( 'openTrunk' )
AddEventHandler( 'openTrunk', function()
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh ~= nil and veh ~= 0 and veh ~= 1 then
        if GetVehicleDoorAngleRatio(veh, 5) > 0 then
            SetVehicleDoorShut(veh, 5, false)
        else
            SetVehicleDoorOpen(veh, 5, false, false)
        end
    end
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(0)			
        local ped = PlayerPedId()
        if IsControlJustPressed(1, 51) then
            if not IsPedSittingInAnyVehicle(ped) then

            elseif IsPedSittingInAnyVehicle(ped) then

            end
        end
	end
end)
