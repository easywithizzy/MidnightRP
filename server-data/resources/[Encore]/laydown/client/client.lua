ESX = nil -- More ESX


local beds = 'v_med_bed2' -- better option that using them in the config
local anim = "anim@gangops@morgue@table@"


-- All for ESX
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)


-- Creates main thread.
Citizen.CreateThread(function()
    while true do -- loops the function
        Citizen.Wait(0) --  Needed So Server Doesn't Crash
        local ped = GetPlayerPed(0) --Gets The Current Ped
        local plycoords = GetEntityCoords(ped) -- Gets the position of ped(player)

        for i = 1, #beds do
        -- Begins to create the needed vars for the thread to work how we want it 
            local bedloc = GetClosestObjectOfType(plycoords.x, plycoords.y, plycoords.z, 1.0, beds, false, false, false)
            local bedPos = GetEntityCoords(bedloc)
            local dist = GetDistanceBetweenCoords(plycoords.x, plycoords.y, plycoords.z, bedPos.x, bedPos.y, bedPos.z, true)
            
        -- Creates the if function so it sees if ped is within a distance with the props listed in the beds var.
            if dist < 1.8 then -- Creates the Press E Prompt
                ESX.ShowHelpNotification("Press ~INPUT_TALK~ to lie down")
                if IsControlJustPressed(0, 51) then
                    mainbed(bedPos.x, bedPos.y, bedPos.z, 167.0) -- Runs function down below
                end
            end
        end
    end
end)


function mainbed(x, y, z, heading)

    SetEntityCoords(GetPlayerPed(0), x, y, z, heading)
    RequestAnimDict(anim)   
    
    Citizen.Wait(0)

    while not HasAnimDictLoaded(anim) do
        Citizen.Wait(0)
    end

    TaskPlayAnim(GetPlayerPed(-1), 'anim@gangops@morgue@table@', 'ko_front', 8.0, -8.0, -1, 1, 0, false, false, false) --anim@gangops@morgue@table@ <Laydown Animation
    SetEntityHeading(GetPlayerPed(-1), heading + 170.0)

    inBed = true

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            local ped = GetPlayerPed(-1) --Gets The Current Ped
            local plycoords = GetEntityCoords(ped) -- Gets the position of ped(player)
            local pedid = PlayerPedId()

            -- Checks in the list of prop hashes to see if there is something in there
                
                -- Begins to create the needed vars for the thread to work how we want it 
            local bedloc = GetClosestObjectOfType(plycoords.x, plycoords.y, plycoords.z, 1.0, 'v_med_bed2', false, false, false)
            local bedPos = GetEntityCoords(bedloc)
            
            if inBed == true then
                if IsControlJustPressed(0, 51) then
                    ESX.ShowHelpNotification("Press ~INPUT_TALK~ to stand up")
                    ClearPedTasks(pedid)
                    FreezeEntityPosition(GetPlayerPed(-1), false)
                    SetEntityCoords(GetPlayerPed(0), x + 1.0, y, z)
                    inBed = false
                end
            end
        end
    end)
end