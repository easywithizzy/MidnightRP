ESX = nil

ClothingRemoved = {
    ['helmet'] = false,
    ['glasses'] = false,
    ['ears'] = false,
    ['watches'] = false,
    ['bracelets'] = false,
    ['mask'] = false,
    ['tshirt'] = false,
    ['chain'] = false,
    ['bags'] = false,
    ['bproof'] = false,
    ['torso'] = false,
    ['arms'] = false,
    ['pants'] = false,
    ['shoes'] = false
}

ClothingNkdMale = {
    ['helmet'] = -1,
    ['glasses'] = -1,
    ['ears'] = -1,
    ['watches'] = -1,
    ['bracelets'] = -1,
    ['mask'] = 0,
    ['tshirt'] = 15,
    ['chain'] = 0,
    ['bags'] = 0,
    ['bproof'] = 0,
	['torso'] = 15,
    ['arms'] = 15,
    ['pants'] = 21,
    ['shoes'] = 34
}
ClothingNkdFemale = {
    ['helmet'] = -1,
    ['glasses'] = -1,
    ['ears'] = -1,
    ['watches'] = -1,
    ['bracelets'] = -1,
    ['mask'] = 0,
    ['tshirt'] = 15,
    ['chain'] = 0,
    ['bags'] = 0,
    ['bproof'] = 0,
	['torso'] = 15,
    ['arms'] = 15,
    ['pants'] = 15,
    ['shoes'] = 35
}

CurrentClothing = nil



Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end
end)

function SetUnsetClothing(item)
    local clothingitem = string.lower(item)
    
	if CurrentClothing == nil then
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(currentskin)
        CurrentClothing = currentskin
        
		if clothingitem == 'arms' then -- Arms are a little special, they are not followed by a _1!
			--print(CurrentClothing[clothingitem].. "-- CurrentClothing")
		else
		--print(CurrentClothing[clothingitem .. '_1'].. "-- CurrentClothing")
		end
		end)
	end
	--print("SetUnsetClothing Triggered")
    TriggerEvent('skinchanger:getSkin', function(skin)
        local mItem = nil
        if skin.sex == 0 then
            --print("MALE")
            mItem = ClothingNkdMale[clothingitem]
        end
        if skin.sex == 1 then
            --print("FEMALE")
            mItem = ClothingNkdFemale[clothingitem]
        end
       
        
		local mColor = 0

		local NewSkin = {}
		if ClothingRemoved[clothingitem] == 1  then
			if clothingitem == 'arms' then -- Again, special code for the fucking arms. 
				NewSkin[clothingitem] = CurrentClothing[clothingitem]
				--print('RESetting '.. NewSkin[clothingitem].. 'to '..CurrentClothing[clothingitem])
			else
			NewSkin[clothingitem .. '_1'] = CurrentClothing[clothingitem .. '_1']
			--print('RESetting '.. NewSkin[clothingitem .. '_1'].. 'to '..CurrentClothing[clothingitem .. '_1'])
			end
			NewSkin[clothingitem .. '_2'] = CurrentClothing[clothingitem .. '_2']
			
			ClothingRemoved[clothingitem] = 0
		else
			if clothingitem == 'arms' then -- These Arms will be the bane of my fucking existence.
				NewSkin[clothingitem] = mItem
				--print('Setting '.. NewSkin[clothingitem].. 'to '..mItem)
			else
				NewSkin[clothingitem .. '_1'] = mItem
				--print('Setting '.. NewSkin[clothingitem .. '_1'].. 'to '..mItem)
			end
		
		NewSkin[clothingitem .. '_2'] = mColor
		
		ClothingRemoved[clothingitem] = 1
		end
		TriggerEvent('skinchanger:loadClothes', skin, NewSkin)
	end)
		
end


RegisterNetEvent('toggleclothing:hat')
AddEventHandler('toggleclothing:hat', function()
SetUnsetClothing('helmet') end)

RegisterNetEvent('toggleclothing:glasses')
AddEventHandler('toggleclothing:glasses', function()
SetUnsetClothing('glasses') end)

RegisterNetEvent('toggleclothing:ears')
AddEventHandler('toggleclothing:ears', function()
SetUnsetClothing('ears') end)

RegisterNetEvent('toggleclothing:watch')
AddEventHandler('toggleclothing:watch', function()
SetUnsetClothing('watches') end)

RegisterNetEvent('toggleclothing:bracelet')
AddEventHandler('toggleclothing:bracelet', function()
SetUnsetClothing('bracelets') end)

RegisterNetEvent('toggleclothing:mask')
AddEventHandler('toggleclothing:mask', function()
SetUnsetClothing('mask') end)

RegisterNetEvent('toggleclothing:bag')
AddEventHandler('toggleclothing:bag', function()
    SetUnsetClothing('bags') end)

RegisterNetEvent('toggleclothing:vest')
AddEventHandler('toggleclothing:vest', function()
    SetUnsetClothing('bproof') end)

RegisterNetEvent('toggleclothing:top')
AddEventHandler('toggleclothing:top', function()
	SetUnsetClothing('tshirt')
	SetUnsetClothing('torso')
    SetUnsetClothing('arms')
    SetUnsetClothing('chain')
    SetUnsetClothing('bproof') end)

RegisterNetEvent('toggleclothing:pants')	
AddEventHandler('toggleclothing:pants', function()
	SetUnsetClothing('pants') end)

RegisterNetEvent('toggleclothing:shoes')
AddEventHandler('toggleclothing:shoes', function()
	SetUnsetClothing('shoes') end)

RegisterNetEvent('toggleclothing:head')
AddEventHandler('toggleclothing:head', function()
    SetUnsetClothing('mask')
    SetUnsetClothing('helmet')
    SetUnsetClothing('glasses')
    SetUnsetClothing('ears')
end)

RegisterNetEvent('toggleclothing:arms')
AddEventHandler('toggleclothing:arms', function()
    SetUnsetClothing('watches')
    SetUnsetClothing('bracelets')
end)

RegisterNetEvent('toggleclothing:all')
AddEventHandler('toggleclothing:all', function()
    SetUnsetClothing('mask')
    SetUnsetClothing('helmet')
    SetUnsetClothing('glasses')
    SetUnsetClothing('ears')
    SetUnsetClothing('watches')
    SetUnsetClothing('bracelets')
    SetUnsetClothing('tshirt')
    SetUnsetClothing('torso')
    SetUnsetClothing('chain')
    SetUnsetClothing('bproof')
    SetUnsetClothing('bags')
    SetUnsetClothing('arms')
    SetUnsetClothing('pants')
    SetUnsetClothing('shoes') 

end)
RegisterCommand('bracelet', function(xPlayer, args, showError)
    TriggerEvent('toggleclothing:bracelet') end, false)

RegisterCommand('watch', function(xPlayer, args, showError)
    TriggerEvent('toggleclothing:watch') end, false)

RegisterCommand('ears', function(xPlayer, args, showError)
    TriggerEvent('toggleclothing:ears') end, false)

RegisterCommand('glasses', function(xPlayer, args, showError)
    TriggerEvent('toggleclothing:glasses') end, false)

RegisterCommand('hat', function(xPlayer, args, showError)
    TriggerEvent('toggleclothing:hat') end, false)

RegisterCommand('mask', function(xPlayer, args, showError)
    TriggerEvent('toggleclothing:mask') end, false)

RegisterCommand('head', function(xPlayer, args, showError)
    TriggerEvent('toggleclothing:head') end, false)

RegisterCommand('top', function(xPlayer, args, showError)
    TriggerEvent('toggleclothing:top') end, false)

RegisterCommand('vest', function(xPlayer, args, showError)
    TriggerEvent('toggleclothing:vest') end, false)

RegisterCommand('bag', function(xPlayer, args, showError)
    TriggerEvent('toggleclothing:bag') end, false)

RegisterCommand('arms', function(xPlayer, args, showError)
    TriggerEvent('toggleclothing:arms') end, false)

RegisterCommand('pants', function(xPlayer, args, showError)
    TriggerEvent('toggleclothing:pants') end, false)

RegisterCommand('shoes', function(xPlayer, args, showError)
    TriggerEvent('toggleclothing:shoes') end, false)

RegisterCommand('clothes', function(xPlayer, args, showError)
    TriggerEvent('toggleclothing:all') end, false)