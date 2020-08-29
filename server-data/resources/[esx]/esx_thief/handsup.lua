local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local canHandsUp = true

AddEventHandler('handsup:toggle', function(param)
	canHandsUp = param
end)

Citizen.CreateThread(function()
	local handsup = false

	while true do
		Citizen.Wait(0)

		if canHandsUp then
			if IsControlJustReleased(0, 43) then
				local playerPed = PlayerPedId()
				DisableControlAction(2, 24, true) -- Attack
				DisableControlAction(2, 257, true) -- Attack 2
				DisableControlAction(2, 25, true) -- Aim
				DisableControlAction(2, 263, true) -- Melee Attack 1
				DisableControlAction(2, Keys['R'], true) -- Reload
				DisableControlAction(2, Keys['SPACE'], true) -- Jump
				DisableControlAction(2, Keys['Q'], true) -- Cover
				DisableControlAction(2, Keys['TAB'], true) -- Select Weapon
				DisableControlAction(2, Keys['F'], true) -- Also 'enter'?
				DisableControlAction(2, Keys['F1'], true) -- Disable phone
				DisableControlAction(2, Keys['F2'], true) -- Inventory
				DisableControlAction(2, Keys['F3'], true) -- Animations
				DisableControlAction(2, Keys['X'], true) -- Disable clearing animation
				DisableControlAction(2, Keys['P'], true) -- Disable pause screen
				DisableControlAction(2, 59, true) -- Disable steering in vehicle
				DisableControlAction(2, Keys['LEFTCTRL'], true) -- Disable going stealth
				DisableControlAction(0, 24, true)  -- Disable weapon
				DisableControlAction(0, 264, true) -- Disable melee
				DisableControlAction(0, 257, true) -- Disable melee
				DisableControlAction(0, 140, true) -- Disable melee
				DisableControlAction(0, 141, true) -- Disable melee
				DisableControlAction(0, 142, true) -- Disable melee
				DisableControlAction(0, 143, true) -- Disable melee
				DisableControlAction(0, 75, true)  -- Disable exit vehicle
				DisableControlAction(27, 75, true) -- Disable exit vehicle
				DisablePlayerFiring(playerPed ,true)
				RequestAnimDict('random@mugging3')
				SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
				while not HasAnimDictLoaded('random@mugging3') do
					Citizen.Wait(100)
				end

				if handsup then
					handsup = false
					ClearPedSecondaryTask(playerPed)
					TriggerServerEvent('esx_thief:update', handsup)
				else
					handsup = true
					SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
					DisableControlAction(2, 24, true) -- Attack
					DisableControlAction(2, 257, true) -- Attack 2
					DisableControlAction(2, 25, true) -- Aim
					DisableControlAction(2, 263, true) -- Melee Attack 1
					DisableControlAction(2, Keys['R'], true) -- Reload
					DisableControlAction(2, Keys['SPACE'], true) -- Jump
					DisableControlAction(2, Keys['Q'], true) -- Cover
					DisableControlAction(2, Keys['TAB'], true) -- Select Weapon
					DisableControlAction(2, Keys['F'], true) -- Also 'enter'?
					DisableControlAction(2, Keys['F1'], true) -- Disable phone
					DisableControlAction(2, Keys['F2'], true) -- Inventory
					DisableControlAction(2, Keys['F3'], true) -- Animations
					DisableControlAction(2, Keys['X'], true) -- Disable clearing animation
					DisableControlAction(2, Keys['P'], true) -- Disable pause screen
					DisableControlAction(2, 59, true) -- Disable steering in vehicle
					DisableControlAction(2, Keys['LEFTCTRL'], true) -- Disable going stealth
					DisableControlAction(0, 24, true)  -- Disable weapon
					DisableControlAction(0, 264, true) -- Disable melee
					DisableControlAction(0, 257, true) -- Disable melee
					DisableControlAction(0, 140, true) -- Disable melee
					DisableControlAction(0, 141, true) -- Disable melee
					DisableControlAction(0, 142, true) -- Disable melee
					DisableControlAction(0, 143, true) -- Disable melee
					DisableControlAction(0, 75, true)  -- Disable exit vehicle
					DisableControlAction(27, 75, true) -- Disable exit vehicle
					TaskPlayAnim(playerPed, 'random@mugging3', 'handsup_standing_base', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
					TriggerServerEvent('esx_thief:update', handsup)
					SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
				end
			end
		end
	end
end)
