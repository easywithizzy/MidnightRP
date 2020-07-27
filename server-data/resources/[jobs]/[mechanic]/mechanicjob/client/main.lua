ESX = nil
--local rgbArray = {}
local Vehicles = {}
local PlayerData = {}
local lsMenuIsShowed = false
local isInLSMarker = false
local myCar = {}
local vehicleClass = nil
local vehiclePrice = 50000

local shopProfitValue = 0
local shopProfit = 10
local shopCart = {}
local totalCartValue = 0
local canClose = false
local society = ""
local stop = false
local deleting = false

--[[
NATIVEUILUA
local menuPool = NativeUI.CreatePool()
menuPool:MouseControlsEnabled(false)
menuPool:MouseEdgeEnabled(false)--]]

local mainMenu = nil 
local bodyMenu = nil
local extrasMenu = nil
local colorMenu = nil
local neonMenu = nil
local upgradeMenu = nil
local cartMenu = nil

local tempBodyParts = nil
local tempExtras = nil
local tempColorParts = nil
local tempNeons = nil
local tempUpgrades = nil

local bodyPartIndex = {
	[1] = { modSpoilers = 1 },
	[2] = { modFrontBumper = 1 },
	[3] = { modRearBumper = 1 },
	[4] = { modSideSkirt = 1 },
	[5] = { modExhaust = 1 },
	[6] = { modGrille = 1 },
	[7] = { modHood = 1 },
	[8] = { modFender = 1 },
	[9] = { modRightFender = 1 },
	[10] = { modRoof = 1 },
	[11] = { modArmor = 1 },
	[12] = { wheels = 1 },
	[13] = { modFrontWheels = 1 },
}

local extrasIndex = {
	[1] = { modPlateHolder = 1 },
	[2] = { modVanityPlate = 1 },
	[3] = { modTrimA = 1 },
	[4] = { modOrnaments = 1 },
	[5] = { modDashboard = 1 },
	[6] = { modDial = 1 },
	[7] = { modDoorSpeaker = 1 },
	[8] = { modSeats = 1 },
	[9] = { modSteeringWheel = 1 },
	[10] = { modShifterLeavers = 1 },
	[11] = { modAPlate = 1 },
	[12] = { modSpeakers = 1 },
	[13] = { modTrunk = 1 },
	[14] = { modHydrolic = 1 },
	[15] = { modEngineBlock = 1 },
	[16] = { modAirFilter = 1 },
	[17] = { modStruts = 1 },
	[18] = { modArchCover = 1 },
	[19] = { modAerials = 1 },
	[20] = { modTrimB = 1 },
	[21] = { modTank = 1 },
	[22] = { modWindows = 1 },
	[23] = { modLivery = 1 },
	[24] = { modHorns = 1 },
}

local windowTintIndex = 1
local colorPartIndex = 1 
local colorTypeIndex = {
	[1] = 1,
	[2] = 1,
	[3] = 1
}
local primaryColorIndex = 1
local secondaryColorIndex = 1
local pearlColorIndex = 1
local primaryCustomColorIndex = { 
	[1] = { label = 'R', index = 0 }, 
	[2] = { label = 'G', index = 0 }, 
	[3] = { label = 'B', index = 0 }
}
local secondaryCustomColorIndex = { 
	[1] = { label = 'R', index = 0 }, 
	[2] = { label = 'G', index = 0 }, 
	[3] = { label = 'B', index = 0 }
}
local primaryPaintFinishIndex = 1
local secondaryPaintFinishIndex = 1
local wheelColorIndex = 1
local tyreSmokeActive = false
local smokeColorIndex = {
	[1] = { label = 'R', index = 0 }, 
	[2] = { label = 'G', index = 0 }, 
	[3] = { label = 'B', index = 0 }
}
local xenonActive = false
local xenonColorIndex = 1

--[[local neonIndex = {
	[1] = { leftNeon = false },
	[2] = { frontNeon = false },
	[3] = { rightNeon = false },
	[4] = { backNeon = false },
	[5] = { r = 0, g = 0, b = 0 },
}--]]
local neonIndex = { 
	[1] = { label = 'R', index = 0 }, 
	[2] = { label = 'G', index = 0 }, 
	[3] = { label = 'B', index = 0 }
}

local neon1 = false
local neon2 = false
local neon3 = false
local neon4 = false

local upgradeIndex = {
	[1] = { modArmor = 1 },
	[2] = { modEngine = 1 },
	[3] = { modTransmission = 1 },
	[4] = { modBrakes = 1 },
	[5] = { modSuspension = 1 },
	[6] = { modTurbo = false },
}

local vehPedIsIn = nil
local vehModsOld = nil
local vehModsNew = nil
local partsCart = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer

	resetMenu() --menu startup

	ESX.TriggerServerCallback('fpwn_customs:getVehiclesPrices', function(vehicles)
		Vehicles = vehicles
	end)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	resetMenu() --trigger menu restart on job change

	ESX.TriggerServerCallback('fpwn_customs:getVehiclesPrices', function(vehicles)
		Vehicles = vehicles
	end)
end)

function resetMenu()
	if not mainMenu and PlayerData.job then
		--local resW, resH = GetResolution()
		if PlayerData.job.name == 'mechanic' then
			mainMenu = RageUI.CreateMenu("Bennys", "~b~Bennys Chop Shop", 5, 250)
			society = 'society_mechanic'
		elseif PlayerData.job.name == 'mecanico' then
			mainMenu = RageUI.CreateMenu("VirtualCustoms", "~b~VirtualCustoms Chop Shop", 5, 250)
			society = 'society_mecanico'
		elseif PlayerData.job.name == 'soa' then
			mainMenu = RageUI.CreateMenu("SonsOfAnarchy", "~b~Sons of Anarchy Chop Shop", 5, 250)
			society = 'society_motoclub'
		end

		if not mainMenu then
			--print("ERROR CREATING JOB MENU!!")
		else
			mainMenu.EnableMouse = false
			mainMenu.Closed = function()
				lsMenuIsShowed = false
				SetVehicleDoorsShut(vehPedIsIn, false)
				if not canClose then
					TriggerEvent('fpwn_customs:resetVehicle', vehModsOld)
				end
			end
		end
	end
end

function CreateLSMenu()
	if not bodyMenu then
		bodyMenu = RageUI.CreateSubMenu(mainMenu)
		bodyMenu.EnableMouse = false
		bodyMenu.Closed = function()
		end
	end
	if not extrasMenu then
		extrasMenu = RageUI.CreateSubMenu(mainMenu)
		extrasMenu.EnableMouse = false
		extrasMenu.Closed = function()
			SetVehicleDoorsShut(vehPedIsIn, false)
		end
	end
	if not colorMenu then
		colorMenu = RageUI.CreateSubMenu(mainMenu)
		colorMenu.EnableMouse = false
		colorMenu.Closed = function()
		end
	end
	if not neonMenu then
		neonMenu = RageUI.CreateSubMenu(mainMenu)
		neonMenu.EnableMouse = false
		neonMenu.Closed = function()
		end
	end
	if not upgradeMenu then
		upgradeMenu = RageUI.CreateSubMenu(mainMenu)
		upgradeMenu.EnableMouse = false
		upgradeMenu.Closed = function()
		end
	end
	if not cartMenu then
		cartMenu = RageUI.CreateSubMenu(mainMenu)
		cartMenu.EnableMouse = false
		cartMenu.Closed = function()
		end
	end
end

--COLOR ARRAY
--[[function buildrgbArray()
	for i = 1, 256, 1 do
		--table.insert(rgbArray, i - 1)
		rgbArray[i] = i - 1
	end
end

buildrgbArray()
--]]

function getCarPrice()
	if vehPedIsIn then
		for i = 1, #Vehicles, 1 do
			if GetEntityModel(vehPedIsIn) == GetHashKey(Vehicles[i].model) then
				vehiclePrice = Vehicles[i].price
				break
			end
		end
	end
end

--REFRESH INDEXES
function RefreshBodyPartIndex()
	for k, v in pairs(vehModsOld) do
		--print("k: " .. k)
		for i = 1, #tempBodyParts, 1 do
			if k == tempBodyParts[i]['mod'] then
				--print("config: " .. tempBodyParts[i]['mod'])
				bodyPartIndex[i][k] = v + (tempBodyParts[i]['mod'] ~= 'wheels' and 2 or 1)
				break
			end
		end
	end
end

function RefreshExtrasIndex()
	for k, v in pairs(vehModsOld) do
		for i = 1, #tempExtras, 1 do
			if k == tempExtras[i]['mod'] then
				extrasIndex[i][k] = v + 2
				break
			end
		end
	end
end

function RefreshPaintIndex()
	windowTintIndex = vehModsOld['windowTint'] + 2
	--colorPartIndex = 1 
	for i = 1, #Config.colorPalette - 2, 1 do
		for k, v in pairs(Config.colorPalette[i]) do
			for x = 1, #v, 1 do
				if vehModsOld['color1'] == v[x] then
					colorTypeIndex[1] = vehModsOld['hasCustomColorPrimary'] == 1 and 7 or i
					primaryPaintFinishIndex = i
					primaryColorIndex = x
				end
				if vehModsOld['color2'] == v[x] then
					colorTypeIndex[2] = vehModsOld['hasCustomColorSecondary'] == 1 and 7 or i
					secondaryPaintFinishIndex = i
					secondaryColorIndex = x
				end
				if vehModsOld['pearlescentColor'] == v[x] then
					colorTypeIndex[3] = i
					pearlColorIndex = x
				end
				if vehModsOld['wheelColor'] == v[x] then
					wheelColorIndex = x
				end
			end
		end
	end
	if vehModsOld['hasCustomColorPrimary'] == 1 then
		primaryCustomColorIndex[1]['index'] = vehModsOld['customColorPrimary'][1]
		primaryCustomColorIndex[2]['index'] = vehModsOld['customColorPrimary'][2]
		primaryCustomColorIndex[3]['index'] = vehModsOld['customColorPrimary'][3]
	end
	if vehModsOld['hasCustomColorSecondary'] == 1 then
		secondaryCustomColorIndex[1]['index'] = vehModsOld['customColorSecondary'][1]
		secondaryCustomColorIndex[2]['index'] = vehModsOld['customColorSecondary'][2]
		secondaryCustomColorIndex[3]['index'] = vehModsOld['customColorSecondary'][3]
	end
	tyreSmokeActive = vehModsOld['modSmokeEnabled'] and true or false
	if tyreSmokeActive then
		smokeColorIndex[1]['index'] = vehModsOld['tyreSmokeColor'][1]
		smokeColorIndex[2]['index'] = vehModsOld['tyreSmokeColor'][2]
		smokeColorIndex[3]['index'] = vehModsOld['tyreSmokeColor'][3]
	end
	xenonActive = vehModsOld['modXenon'] and true or false
	if xenonActive then
		xenonColorIndex = vehModsOld['xenonColor'] + 2
	end
end

function RefreshNeonIndex()
	--[[
		0 = Left
		2 = Front
		1 = Right
		3 = Back
	--]]
	neon1 = vehModsOld['neonEnabled'][1] and true or false
	neon2 = vehModsOld['neonEnabled'][2] and true or false
	neon3 = vehModsOld['neonEnabled'][3] and true or false
	neon4 = vehModsOld['neonEnabled'][4] and true or false
	neonIndex[1]['index'] = vehModsOld['neonColor'][1]
	neonIndex[2]['index'] = vehModsOld['neonColor'][2]
	neonIndex[3]['index'] = vehModsOld['neonColor'][3]
end

function RefreshUpgradeIndex()
	for k, v in pairs(vehModsOld) do 
		for i = 1, #tempUpgrades, 1 do
			if k == tempUpgrades[i]['mod'] and tempUpgrades[i]['modType'] ~= 18 then
				upgradeIndex[i][k] = v + 2
				break
			elseif k == tempUpgrades[i]['mod'] and tempUpgrades[i]['modType'] == 18 then
				upgradeIndex[i][k] = v and true or false
				break
			end
		end
	end
end

--RESET ITEM LISTS
function ResetBodyPartItems()
	if tempBodyParts then
		for i = 1, #tempBodyParts, 1 do
			if i ~= 12 then
				for x = 1, #tempBodyParts[i]['items']['label'] do
				    tempBodyParts[i]['items']['label'][x] = nil
				end
			end
		end
	end
end

function ResetWheelItems()
	if tempBodyParts then
		for x = 1, #tempBodyParts[13]['items']['label'] do
		    tempBodyParts[13]['items']['label'][x] = nil
		end
	end
end

function ResetExtraItems()
	if tempExtras then
		for i = 1, #tempExtras, 1 do
			for x = 1, #tempExtras[i]['items']['label'] do
			    tempExtras[i]['items']['label'][x] = nil
			end
		end
	end
end

function ResetPaintItems()
	windowTintIndex = 1
	colorPartIndex = 1 
	colorTypeIndex[1] = 1
	colorTypeIndex[2] = 1
	colorTypeIndex[3] = 1
	primaryColorIndex = 1
	secondaryColorIndex = 1
	primaryCustomColorIndex[1]['index'] = 0
	primaryCustomColorIndex[2]['index'] = 0
	primaryCustomColorIndex[3]['index'] = 0
	secondaryCustomColorIndex[1]['index'] = 0
	secondaryCustomColorIndex[2]['index'] = 0
	secondaryCustomColorIndex[3]['index'] = 0
	primaryPaintFinishIndex = 1
	secondaryPaintFinishIndex = 1
	pearlColorIndex = 1
	wheelColorIndex = 1
	tyreSmokeActive = false
	smokeColorIndex[1]['index'] = 0
	smokeColorIndex[2]['index'] = 0
	smokeColorIndex[3]['index'] = 0
	xenonActive = false
	xenonColorIndex = 1
end

function ResetNeonItems()
	neon1 = false
	neon2 = false
	neon3 = false
	neon4 = false
	neonIndex[1]['index'] = 0
	neonIndex[2]['index'] = 0
	neonIndex[3]['index'] = 0
end

function ResetUpgradeItems()
	if tempUpgrades then
		for i = 1, #tempUpgrades, 1 do
			for x = 1, #tempUpgrades[i]['items']['label'] do
			    tempUpgrades[i]['items']['label'][x] = nil
			end
		end
	end
end

--BUILD ITEM LISTS
function BuildBodyPartsLabel()
	local modCount = 0
	local modName = ""
	local label = ""
	for i = 1, #tempBodyParts, 1 do
		modCount = GetNumVehicleMods(vehPedIsIn, tempBodyParts[i]['modType'])
		if modCount > 0 and i < 12 then
			for x = 1, modCount, 1 do
				--[[modName = GetModTextLabel(vehPedIsIn, tempBodyParts[i]['modType'], x)
				label = GetLabelText(modName)
				if label == "NULL" then
					label = "Custom " .. tempBodyParts[i]['label']
				end
				if #label > 10 then
					label = label:sub(1, 10)
					print("label cut: " .. label)
				end--]]
				if x == 1 then
					--table.insert(tempBodyParts[i]['items']['label'], "Stock " .. label .. " [" .. x .. "/" .. modCount + 1 .. "]")
					table.insert(tempBodyParts[i]['items']['label'], "[" .. x .. "/" .. modCount + 1 .. "]")
				end
				--label = label .. " [" .. x + 1 .. "/" .. modCount + 1 .. "]"
				label = "[" .. x + 1 .. "/" .. modCount + 1 .. "]"
				table.insert(tempBodyParts[i]['items']['label'], label)
			end
		end
	end
end

function BuildWheelsLabel()
	local modCount = GetNumVehicleMods(vehPedIsIn, tempBodyParts[13]['modType'])
	if modCount > 0 then
		for x = 1, modCount, 1 do
			if x == 1 then
				table.insert(tempBodyParts[13]['items']['label'], "[" .. x .. "/" .. modCount + 1 .. "]")
			end
			label = "[" .. x + 1 .. "/" .. modCount + 1 .. "]"
			table.insert(tempBodyParts[13]['items']['label'], label)
		end
	end
end

function BuildExtrasLabel()
	local modCount = 0
	local modName = ""
	local label = ""
	for i = 1, #tempExtras, 1 do
		modCount = GetNumVehicleMods(vehPedIsIn, tempExtras[i]['modType'])
		if modCount > 0 then
			for x = 1, modCount, 1 do
				--[[modName = GetModTextLabel(vehPedIsIn, tempExtras[i]['modType'], x)
				label = GetLabelText(modName)
				if label == "NULL" then
					label = "Custom " .. tempExtras[i]['label']
				end--]]
				if x == 1 then
					--table.insert(tempExtras[i]['items']['label'], "Stock " .. label .. " [" .. x .. "/" .. modCount + 1 .. "]")
					table.insert(tempExtras[i]['items']['label'], "[" .. x .. "/" .. modCount + 1 .. "]")
				end
				--label = label .. " [" .. x + 1 .. "/" .. modCount + 1 .. "]"
				label = "[" .. x + 1 .. "/" .. modCount + 1 .. "]"
				table.insert(tempExtras[i]['items']['label'], label)
			end
		end
	end
end

function BuildUpgradesLabel()
	local modCount = 0
	local modName = ""
	local label = ""
	for i = 1, #tempUpgrades, 1 do
		modCount = GetNumVehicleMods(vehPedIsIn, tempUpgrades[i]['modType'])
		if modCount > 0 then
			for x = 1, modCount, 1 do
				--[[modName = GetModTextLabel(vehPedIsIn, tempUpgrades[i]['modType'], x)
				label = GetLabelText(modName)--]]
				--[[if label == "NULL" then
					label = "Custom " .. tempUpgrades[i]['label']
				end--]]
				if x == 1 then
					--local label1 = tempUpgrades[i]['label']
					--table.insert(tempUpgrades[i]['items']['label'], "Stock " .. label1 .. " [" .. x .. "/" .. modCount + 1 .. "]")
					table.insert(tempUpgrades[i]['items']['label'], "[" .. x .. "/" .. modCount + 1 .. "]")
				end
				--label = label .. " [" .. x + 1 .. "/" .. modCount + 1 .. "]"
				label = "[" .. x + 1 .. "/" .. modCount + 1 .. "]"
				table.insert(tempUpgrades[i]['items']['label'], label)
			end
		end
	end
end

function addToCart(label, mod, modType, index, price)
	local item = findKey(shopCart, mod)
	if item then
		shopCart[mod]['label'] = label
		shopCart[mod]['modType'] = modType
		shopCart[mod]['index'] = index
		shopCart[mod]['price'] = price
	else
		item = { label = label, modType = modType, index = index, price = price }
		shopCart[mod] = item
	end
	calcCartValue()
end

function removeFromCart(mod)
	local item = findKey(shopCart, mod)
	if item then
		shopCart[mod] = nil
		calcCartValue()
	end
end

function calcCartValue()
	shopProfitValue = 0
	totalCartValue = 0
	for k, v in pairs(shopCart) do
		--print("k: " .. k)
		--print("v['price']: " .. v['price'])
		local c = v['price'] * (shopProfit / 100)
		shopProfitValue = math.round(shopProfitValue + c)
		totalCartValue = math.round(totalCartValue + v['price'] + c)
	end
end

function finishPurchase()
	local vehModsNew = ESX.Game.GetVehicleProperties(vehPedIsIn)
	--passar fatura
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	local playerId =  GetPlayerServerId(closestPlayer)
	TriggerServerEvent('fpwn_customs:finishPurchase', society, vehModsNew, shopCart, playerId, shopProfit)
	RageUI.CloseAll()
end

function terminatePurchase()
	for k, v in pairs(shopCart) do
		shopCart[k] = nil
	end
	if lsMenuIsShowed then
		RageUI.CloseAll()
	end
	lsMenuIsShowed = false
	stop = false
	vehModsOld = nil
end

function compareMods(label, mod, modType, index, price)
	local vehModsNew = ESX.Game.GetVehicleProperties(vehPedIsIn)
	if (mod ~= 'neonColor' and mod ~= 'tyreSmokeColor' and mod ~= 'customColorPrimary' and mod ~= 'customColorSecondary' and vehModsOld[mod] ~= vehModsNew[mod]) or 
		--apenas ligar neons
		(mod == 'leftNeon' and not vehModsOld['neonEnabled'][1] and vehModsNew['neonEnabled'][1]) or 
		(mod == 'rightNeon' and not vehModsOld['neonEnabled'][2] and vehModsNew['neonEnabled'][2]) or 
		(mod == 'frontNeon' and not vehModsOld['neonEnabled'][3] and vehModsNew['neonEnabled'][3]) or 
		(mod == 'backNeon' and not vehModsOld['neonEnabled'][4] and vehModsNew['neonEnabled'][4]) or
		--mudar cor da neon
		(mod == 'neonColor' and (vehModsOld['neonColor'][1] ~= vehModsNew['neonColor'][1] or vehModsOld['neonColor'][2] ~= vehModsNew['neonColor'][2] or vehModsOld['neonColor'][3] ~= vehModsNew['neonColor'][3])) or
		(mod == 'tyreSmokeColor' and (vehModsOld['tyreSmokeColor'][1] ~= vehModsNew['tyreSmokeColor'][1] or vehModsOld['tyreSmokeColor'][2] ~= vehModsNew['tyreSmokeColor'][2] or vehModsOld['tyreSmokeColor'][3] ~= vehModsNew['tyreSmokeColor'][3])) or
		(mod == 'xenonColor' and vehModsOld['xenonColor'] ~= vehModsNew['xenonColor']) or
		(mod == 'customColorPrimary' and (vehModsOld['customColorPrimary'][1] ~= vehModsNew['customColorPrimary'][1] or vehModsOld['customColorPrimary'][2] ~= vehModsNew['customColorPrimary'][2] or vehModsOld['customColorPrimary'][3] ~= vehModsNew['customColorPrimary'][3])) or 
		(mod == 'customColorSecondary' and (vehModsOld['customColorSecondary'][1] ~= vehModsNew['customColorSecondary'][1] or vehModsOld['customColorSecondary'][2] ~= vehModsNew['customColorSecondary'][2] or vehModsOld['customColorSecondary'][3] ~= vehModsNew['customColorSecondary'][3])) then

		addToCart(label, mod, modType, index, price)
		if mod == 'customColorPrimary' then
			removeFromCart('color1')
		elseif mod == 'customColorSecondary' then
			removeFromCart('color2')
		elseif mod == 'color1' then
			removeFromCart('customColorPrimary')
		elseif mod == 'color2' then
			removeFromCart('customColorSecondary')
		end
	else
		if (mod == 'leftNeon' and not vehModsNew['neonEnabled'][1]) and 
			(mod == 'rightNeon' and not vehModsNew['neonEnabled'][2]) and 
			(mod == 'frontNeon' and not vehModsNew['neonEnabled'][3]) and 
			(mod == 'backNeon' and not vehModsNew['neonEnabled'][4]) then

			removeFromCart('neonColor')
		elseif mod == 'modSmokeEnabled' then
			removeFromCart('tyreSmokeColor')
		elseif mod == 'modXenon' then
			removeFromCart('xenonColor')
		end
		removeFromCart(mod)
	end
end

function calcModPrice(parcel)
	local val = 0
	val = math.round(vehiclePrice * (parcel / 100))
	return val
end

function DeleteFromCart(k, modType)
	local vehModsNew = ESX.Game.GetVehicleProperties(vehPedIsIn)
	if modType == -1 then
		if k == 'customColorPrimary' then
			if vehModsOld['hasCustomColorPrimary'] == 1 then
				SetVehicleCustomPrimaryColour(vehicle, vehModsOld['customColorPrimary'][1], vehModsOld['customColorPrimary'][2], vehModsOld['customColorPrimary'][3])
			else
				ClearVehicleCustomPrimaryColour(vehPedIsIn)
			end
		elseif k == 'customColorSecondary' then
			if vehModsOld['hasCustomColorSecondary'] == 1 then
				SetVehicleCustomSecondaryColour(vehicle, vehModsOld['customColorSecondary'][1], vehModsOld['customColorSecondary'][2], vehModsOld['customColorSecondary'][3])
			else
				ClearVehicleCustomSecondaryColour(vehPedIsIn)
			end
		elseif k == 'primaryPaintFinish' then
			SetVehicleColours(vehPedIsIn, vehModsOld['color1'], vehModsNew['color2'])
		elseif k == 'secondaryPaintFinish' then 
			SetVehicleColours(vehPedIsIn, vehModsNew['color1'], vehModsOld['color2'])
		elseif k == 'color1' then
			SetVehicleColours(vehPedIsIn, vehModsOld['color1'], vehModsNew['color2'])
		elseif k == 'color2' then 
			SetVehicleColours(vehPedIsIn, vehModsNew['color1'], vehModsOld['color2'])
		elseif k == 'pearlescentColor' then
			SetVehicleExtraColours(vehPedIsIn, vehModsOld['pearlescentColor'], vehModsNew['wheelColor'])
		elseif k == 'wheelColor' then
			SetVehicleExtraColours(vehPedIsIn, vehModsNew['pearlescentColor'], vehModsOld['wheelColor'])
		elseif k == 'windowTint' then
			SetVehicleWindowTint(vehPedIsIn, vehModsOld['windowTint'])
		elseif k == 'tyreSmokeColor' then
			SetVehicleTyreSmokeColor(vehPedIsIn, vehModsOld['tyreSmokeColor'][1], vehModsOld['tyreSmokeColor'][2], vehModsOld['tyreSmokeColor'][3])
		elseif k == 'xenonColor' then
			SetVehicleXenonLightsColour(vehPedIsIn, vehModsOld['xenonColor'])
		elseif k == 'neonColor' then
			SetVehicleNeonLightsColour(vehPedIsIn, vehModsOld['neonColor'][1], vehModsOld['neonColor'][2], vehModsOld['neonColor'][3])
		elseif k == 'leftNeon' then
			SetVehicleNeonLightEnabled(vehPedIsIn, 0, vehModsOld['neonEnabled'][1])
		elseif k == 'rightNeon' then
			SetVehicleNeonLightEnabled(vehPedIsIn, 1, vehModsOld['neonEnabled'][2])
		elseif k == 'frontNeon' then
			SetVehicleNeonLightEnabled(vehPedIsIn, 2, vehModsOld['neonEnabled'][3])
		elseif k == 'backNeon' then
			SetVehicleNeonLightEnabled(vehPedIsIn, 3, vehModsOld['neonEnabled'][4])
		end
	else
		--[[if k == 'modTurbo' or k == 'modSmokeEnabled' or k == 'modXenon' then
			print("vehModsOld[k]: " .. tostring(vehModsOld[k]))
			print("modType: " .. modType)
			if vehModsOld[k] or vehModsOld[k] == 1 then
				ToggleVehicleMod(vehPedIsIn, modType, true)
			elseif not vehModsOld[k] or vehModsOld[k] == 0 then
				ToggleVehicleMod(vehPedIsIn, modType, false)
			end--]]
		if k == 'modTurbo' or k == 'modSmokeEnabled' or k == 'modXenon' then
			if vehModsOld[k] or vehModsOld[k] == 1 then
				ToggleVehicleMod(vehPedIsIn, modType, true)
			elseif not vehModsOld[k] or vehModsOld[k] == 0 then
				ToggleVehicleMod(vehPedIsIn, modType, false)
			end
			removeFromCart('modTurbo')
			removeFromCart('modSmokeEnabled')
			removeFromCart('modXenon')
		elseif k == 'modLivery' then
			SetVehicleMod(vehPedIsIn, modType, vehModsOld['modLivery'], false)
			SetVehicleLivery(vehPedIsIn, vehModsOld['modLivery'])
		elseif k == 'wheels' or k == 'modFrontWheels' then
			SetVehicleWheelType(vehPedIsIn, vehModsOld['wheels'])
            SetVehicleMod(vehPedIsIn, 23, vehModsOld['modFrontWheels'], false)
		else
			SetVehicleMod(vehPedIsIn, modType, vehModsOld[k], false)
		end
	end
	removeFromCart(k)
	--refresh indexes
	RefreshBodyPartIndex()
	RefreshExtrasIndex()
	RefreshPaintIndex()
	RefreshNeonIndex()
	RefreshUpgradeIndex()
	deleting = false
end

-- Activate menu when player is inside marker
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed, false) then
			if not vehPedIsIn and isInLSMarker then
				vehPedIsIn = GetVehiclePedIsIn(playerPed, false)
				vehModsOld = ESX.Game.GetVehicleProperties(vehPedIsIn)
				TriggerServerEvent('fpwn_customs:checkVehicle', vehModsOld['plate'])
			end
			local coords = GetEntityCoords(PlayerPedId())
			local currentZone, zone, lastZone
			if (PlayerData.job and PlayerData.job.name == 'mechanic') or not Config.IsMechanicJobOnly and not lsMenuIsShowed then
				if GetDistanceBetweenCoords(coords, Config.Zones[1]['Pos']['x'], Config.Zones[1]['Pos']['y'], Config.Zones[1]['Pos']['z'], true) < Config.Zones[1]['Size']['x'] then
					isInLSMarker  = true
					ESX.ShowHelpNotification(Config.Zones[1]['Hint'])
				else
					isInLSMarker  = false
				end
			end
			if (PlayerData.job and PlayerData.job.name == 'mecanico') or not Config.IsMechanicJobOnly and not lsMenuIsShowed then
				if GetDistanceBetweenCoords(coords, Config.Zones[2]['Pos']['x'], Config.Zones[2]['Pos']['y'], Config.Zones[2]['Pos']['z'], true) < Config.Zones[2]['Size']['x'] then
					isInLSMarker  = true
					ESX.ShowHelpNotification(Config.Zones[2]['Hint'])
				else
					isInLSMarker  = false
					RageUI.CloseAll()
				end
			end
			if (PlayerData.job and PlayerData.job.name == 'soa') or not Config.IsMechanicJobOnly and not lsMenuIsShowed then
				if GetDistanceBetweenCoords(coords, Config.Zones[3]['Pos']['x'], Config.Zones[3]['Pos']['y'], Config.Zones[3]['Pos']['z'], true) < Config.Zones[3]['Size']['x'] then
					isInLSMarker  = true
					ESX.ShowHelpNotification(Config.Zones[3]['Hint'])
				else
					isInLSMarker  = false
				end
			end

			if lsMenuIsShowed and not isInLSMarker then
				--FreezeEntityPosition(vehPedIsIn, false)
				RageUI.CloseAll()
				lsMenuIsShowed = false
				SetVehicleDoorsShut(vehPedIsIn, false)
				if not canClose then
					TriggerEvent('fpwn_customs:saveVehicle', vehModsOld)
				end
			end

			if IsControlJustReleased(0, 38) and not lsMenuIsShowed and isInLSMarker then
				if (PlayerData.job and (PlayerData.job.name == 'mechanic' or PlayerData.job.name == 'mecanico' or PlayerData.job.name == 'soa')) or not Config.IsMechanicJobOnly then
					--vehPedIsIn = GetVehiclePedIsIn(playerPed, false)
					terminatePurchase()
					getCarPrice()
					vehicleClass = GetVehicleClass(vehPedIsIn)
					--print("vehicleClass: " .. vehicleClass)
					if ((vehicleClass ~= 8 or not Config.IsMotorCycleBikerOnly) and PlayerData.job.name == 'mechanic') or 
						((vehicleClass ~= 8 or not Config.IsMotorCycleBikerOnly) and PlayerData.job.name == 'mecanico') or
						(vehicleClass == 8 and PlayerData.job.name == 'soa') then

						--RageUI.CloseAll()
						vehModsOld = ESX.Game.GetVehicleProperties(vehPedIsIn)
						SetVehicleModKit(vehPedIsIn, 0)
						TriggerServerEvent('fpwn_customs:saveVehicle', vehModsOld)

						--resetItems
						ResetBodyPartItems()
						ResetWheelItems()
						ResetExtraItems()
						ResetPaintItems()
						ResetNeonItems()
						ResetUpgradeItems()
						
						if not tempBodyParts then tempBodyParts = Config.bodyParts end
						if not tempExtras then tempExtras = Config.extras end
						if not tempColorParts then tempColorParts = Config.colorParts end
						if not tempNeons then tempNeons = Config.neons end
						if not tempUpgrades then tempUpgrades = Config.upgrades end
						
						if vehicleClass == 8 and #tempBodyParts[12]['wheelType'] < 8 then
							table.insert(tempBodyParts[12]['items'], _U('motorcycle'))
							table.insert(tempBodyParts[12]['wheelType'], 6)
						elseif vehicleClass ~= 8 and #tempBodyParts[12]['wheelType'] == 8 then
							table.remove(tempBodyParts[12]['items'])
							table.remove(tempBodyParts[12]['wheelType'])
						end

						--refresh indexes
						RefreshBodyPartIndex()
						RefreshExtrasIndex()
						RefreshPaintIndex()
						RefreshNeonIndex()
						RefreshUpgradeIndex()
						--refresh item names
						BuildBodyPartsLabel()
						BuildWheelsLabel()
						BuildExtrasLabel()
						BuildUpgradesLabel()

						lsMenuIsShowed = true
						--SetVehicleDoorsLocked(vehPedIsIn, 4)
						--FreezeEntityPosition(vehPedIsIn, true)
						CreateLSMenu()
						myCar = vehModsOld

						shopProfit = Config.shopProfit

						RageUI.Visible(mainMenu, not RageUI.Visible(mainMenu))
					end
				end
			end

            RageUI.IsVisible(mainMenu, true, true, true, function()
				RageUI.Button(_U('bodyparts') , "", {
						LeftBadge = nil,
						RightBadge = nil,
						RightLabel = "→→→"
					}, true, function(Hovered, Active, Selected)
						if Selected then
							--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
						end
						if Hovered then
						-- My action the button is hovered by the mouse
						end
						if Active then
						-- My action the button is hightlighted
						end
					end, bodyMenu)  
				RageUI.Button("Extras" , "", {
						LeftBadge = nil,
						RightBadge = nil,
						RightLabel = "→→→"
					}, true, function(Hovered, Active, Selected)
						if Selected then
							--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
							SetVehicleDoorOpen(vehPedIsIn, 0, false)
							SetVehicleDoorOpen(vehPedIsIn, 1, false)
							SetVehicleDoorOpen(vehPedIsIn, 2, false)
							SetVehicleDoorOpen(vehPedIsIn, 3, false)
							SetVehicleDoorOpen(vehPedIsIn, 4, false)
							SetVehicleDoorOpen(vehPedIsIn, 5, false)
						end
						if Hovered then
						-- My action the button is hovered by the mouse
						end
						if Active then
						-- My action the button is hightlighted
						end
					end, extrasMenu)
				RageUI.Button(_U('respray') , "", {
						LeftBadge = nil,
						RightBadge = nil,
						RightLabel = "→→→"
					}, true, function(Hovered, Active, Selected)
						if Selected then
							--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
						end
						if Hovered then
						-- My action the button is hovered by the mouse
						end
						if Active then
						-- My action the button is hightlighted
						end
					end, colorMenu)
				RageUI.Button(_U('neons') , "", {
						LeftBadge = nil,
						RightBadge = nil,
						RightLabel = "→→→"
					}, true, function(Hovered, Active, Selected)
						if Selected then
							--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
						end
						if Hovered then
						-- My action the button is hovered by the mouse
						end
						if Active then
						-- My action the button is hightlighted
						end
					end, neonMenu)  
				RageUI.Button(_U('upgrades') , "", {
						LeftBadge = nil,
						RightBadge = nil,
						RightLabel = "→→→"
					}, true, function(Hovered, Active, Selected)
						if Selected then
							--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
						end
						if Hovered then
						-- My action the button is hovered by the mouse
						end
						if Active then
						-- My action the button is hightlighted
						end
					end, upgradeMenu) 
				RageUI.Button(_U('cart') , "", {
						LeftBadge = nil,
						RightBadge = nil,
						RightLabel = "→→→"
					}, true, function(Hovered, Active, Selected)
						if Selected then
							--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
						end
						if Hovered then
						-- My action the button is hovered by the mouse
						end
						if Active then
						-- My action the button is hightlighted
						end
					end, cartMenu) 
				end, function()
				---Panels
				end
			)
	        
            RageUI.IsVisible(bodyMenu, true, true, true, function()
            	local menuItemCount = 0
	            	for i = 1, #tempBodyParts, 1 do
	            		local modCount = GetNumVehicleMods(vehPedIsIn, tempBodyParts[i]['modType'])
						--print(tempBodyParts[i]['mod'] .. ' modCount: ' .. modCount)
						local bodyIndex = 1
						bodyIndex = bodyPartIndex[i][tempBodyParts[i]['mod']]
						if modCount > 0 then
							if vehicleClass ~= 8 or (tempBodyParts[i]['mod'] ~= 'wheels' and vehicleClass == 8) then
								local itemLabel = tempBodyParts[i]['label']
								if tempBodyParts[i]['mod'] ~= 'wheels' then
									itemLabel = itemLabel .. " (" .. (calcModPrice(tempBodyParts[i]['items']['price']) .. "$" or "---") .. ")" 
								end
								RageUI.List(itemLabel,
									(tempBodyParts[i]['mod'] ~= 'wheels') and tempBodyParts[i]['items']['label'] or tempBodyParts[i]['items'], 
									bodyIndex,
									'{Price}', 
									{}, 
									true, 
									function(Hovered, Active, Selected, Index)
										if bodyPartIndex[i][tempBodyParts[i]['mod']] ~= Index and Index <= modCount + 1 then -- +1 para contar com o index da peça STOCK
											bodyPartIndex[i][tempBodyParts[i]['mod']] = Index
											if Selected then
												
											end
										end
									end,
									function(Index, CurrentItems)
							            local itemIndex = Index - (tempBodyParts[i]['mod'] ~= 'wheels' and 2 or 1)
							            if tempBodyParts[i]['mod'] ~= 'wheels' then
							            	SetVehicleMod(vehPedIsIn, tempBodyParts[i]['modType'], itemIndex, false)
							            	compareMods(tempBodyParts[i]['label'], tempBodyParts[i]['mod'], tempBodyParts[i]['modType'], itemIndex, calcModPrice(tempBodyParts[i]['items']['price']))
							            elseif tempBodyParts[i]['mod'] == 'wheels' then
							            	bodyPartIndex[13][tempBodyParts[13]['mod']] = 1
								            SetVehicleWheelType(vehPedIsIn, tempBodyParts[i]['wheelType'][Index])
								            SetVehicleMod(vehPedIsIn, 23, -1, false)
								            compareMods(tempBodyParts[13]['label'], tempBodyParts[13]['mod'], tempBodyParts[13]['modType'], 1, 0)
								            ResetWheelItems()
								            BuildWheelsLabel()
								        elseif tempBodyParts[i]['mod'] == 'modFrontWheels' then
								        	SetVehicleMod(vehPedIsIn, 23, Index - 2, false)
								            if vehicleClass == 8 then
								            	SetVehicleMod(vehPedIsIn, 24, Index - 2, false)
								            end
								        	compareMods(tempBodyParts[i]['label'], tempBodyParts[i]['mod'], tempBodyParts[i]['modType'], itemIndex, calcModPrice(tempBodyParts[i]['items']['price']))
							            end
							        end
								)
								menuItemCount = menuItemCount + 1
							end
						end
	            	end
	            	if menuItemCount == 0 then
	            		RageUI.Button(_U('noStock') , _U('noStockTxt'), {
							LeftBadge = nil,
							RightBadge = nil,
							RightLabel = "Go back"
						}, true, function(Hovered, Active, Selected)
							if Selected then
								--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
							end
							if Hovered then
							-- My action the button is hovered by the mouse
							end
							if Active then
							-- My action the button is hightlighted
							end
						end, mainMenu)
	            	end
				end, function()
				---Panels
				end
			)
			RageUI.IsVisible(extrasMenu, true, true, true, function()
					local menuItemCount = 0
	            	for i = 1, #tempExtras, 1 do
	            		local modCount = GetNumVehicleMods(vehPedIsIn, tempExtras[i]['modType'])
						--print(tempExtras[i]['mod'] .. ' modCount: ' .. modCount)
						local extraIndex = 1
						extraIndex = extrasIndex[i][tempExtras[i]['mod']]
						if modCount > 0 then
							local itemLabel = tempExtras[i]['label'] .. " (" .. (calcModPrice(tempExtras[i]['items']['price']) .. "$" or "---") .. ")"
							RageUI.List(itemLabel,
								tempExtras[i]['items']['label'], 
								extraIndex,
								'{Price}', 
								{}, 
								true, 
								function(Hovered, Active, Selected, Index)
									if extrasIndex[i][tempExtras[i]['mod']] ~= Index and Index <= modCount + 1 then -- +1 para contar com o index da peça STOCK
										extrasIndex[i][tempExtras[i]['mod']] = Index
										if Selected then
									
										end
									end
								end,
								function(Index, CurrentItems)
						            local itemIndex = Index - 2
						            SetVehicleMod(vehPedIsIn, tempExtras[i]['modType'], itemIndex, false)
						            if tempExtras[i]['mod'] == 'modLivery' then
						            	SetVehicleLivery(vehPedIsIn, itemIndex)
						            end
						            compareMods(tempExtras[i]['label'], tempExtras[i]['mod'], tempExtras[i]['modType'], itemIndex, calcModPrice(tempExtras[i]['items']['price']))
						        end
							)
							menuItemCount = menuItemCount + 1
						end
	            	end
	            	if menuItemCount == 0 then
	            		RageUI.Button(_U('noStock') , _U('noStockTxt'), {
							LeftBadge = nil,
							RightBadge = nil,
							RightLabel = "Go back"
						}, true, function(Hovered, Active, Selected)
							if Selected then
								--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
							end
							if Hovered then
							-- My action the button is hovered by the mouse
							end
							if Active then
							-- My action the button is hightlighted
							end
						end, mainMenu)
	            	end
				end, function()
				---Panels
				end
			)
			RageUI.IsVisible(colorMenu, true, true, true, function()
					if bodyPartIndex[13]['modFrontWheels'] ~= 1 then
						local item = findItem(tempColorParts['label'], _U('wheels'))
						local itemPos = item and item or 0
						if itemPos == 0 then
							table.insert(tempColorParts['label'], _U('wheels'))
							table.insert(tempColorParts['mod'], 'wheels')
						end
					else
						local item = findItem(tempColorParts['label'], _U('wheels'))
						local itemPos = item and item or 0
						if itemPos > 1 then
							tempColorParts['label'][itemPos] = nil
							tempColorParts['mod'][itemPos] = nil
							colorPartIndex = 1
						end
					end
					RageUI.Checkbox(Config.tireSmoke['label'] .. " (" .. (calcModPrice(Config.tireSmoke['price']) .. "$" or "---") .. ")", 
						'{Price}', 
						tyreSmokeActive, 
						{ Style = RageUI.CheckboxStyle.Tick }, 
						function(Hovered, Selected, Active, Checked)
							if Active then
								tyreSmokeActive = Checked and true or false
								if tyreSmokeActive then
									local item = findItem(tempColorParts['label'], _U('tireSmoke'))
									local itemPos = item and item or 0
									if itemPos == 0 then
										table.insert(tempColorParts['label'], _U('tireSmoke'))
										table.insert(tempColorParts['mod'], 'tireSmoke')
									end
								else
									local item = findItem(tempColorParts['label'], _U('tireSmoke'))
									local itemPos = item and item or 0
									if itemPos > 1 then
										tempColorParts['label'][itemPos] = nil
										tempColorParts['mod'][itemPos] = nil
										colorPartIndex = 1
									end
								end
								ToggleVehicleMod(vehPedIsIn, 20, tyreSmokeActive)
								compareMods(Config.tireSmoke['label'], Config.tireSmoke['mod'], 20, tyreSmokeActive, ((tyreSmokeActive and vehModsOld['modSmokeEnabled']) or (not tyreSmokeActive and vehModsOld['modSmokeEnabled'])) and 0 or calcModPrice(Config.tireSmoke['price']))
							end
						end
					)
					--[[RageUI.Checkbox(Config.xenon['label'] .. " (" .. (calcModPrice(Config.xenon['price']) .. "€" or "---") .. ")", 
						'{Price}', 
						xenonActive, 
						{ Style = RageUI.CheckboxStyle.Tick }, 
						function(Hovered, Selected, Active, Checked)
							if Active then
								xenonActive = Checked and true or false
								if xenonActive then
									local item = findItem(tempColorParts['label'], _U('headlights'))
									local itemPos = item and item or 0
									if itemPos == 0 then
										table.insert(tempColorParts['label'], _U('headlights'))
										table.insert(tempColorParts['mod'], 'headlights')
									end
								else
									local item = findItem(tempColorParts['label'], _U('headlights'))
									local itemPos = item and item or 0
									if itemPos > 1 then
										tempColorParts['label'][itemPos] = nil
										tempColorParts['mod'][itemPos] = nil
										colorPartIndex = 1
									end
								end
								ToggleVehicleMod(vehPedIsIn, 22, xenonActive)
								compareMods(Config.xenon['label'], Config.xenon['mod'], 22, xenonActive, ((xenonActive and vehModsOld['modXenon']) or (not xenonActive and vehModsOld['modXenon'])) and 0 or calcModPrice(Config.xenon['price']))
							end
						end
					)--]]
					RageUI.List(_U('paintPart'),
						tempColorParts['label'], 
						colorPartIndex,
						'{Price}', 
						{}, 
						true, 
						function(Hovered, Active, Selected, Index)
						end,
						function(Index, CurrentItems)
							colorPartIndex = Index
				        end
					)
					if colorPartIndex <= 3 then
						RageUI.List(_U('paintType'),
							Config.resprayTypes[colorPartIndex]['label'], 
							colorTypeIndex[colorPartIndex],
							'{Price}', 
							{}, 
							true, 
							function(Hovered, Active, Selected, Index)
							end,
							function(Index, CurrentItems)
								colorTypeIndex[colorPartIndex] = Index
								if tempColorParts['mod'][colorPartIndex] == 'primary' then
									primaryColorIndex = 1
									ClearVehicleCustomPrimaryColour(vehPedIsIn)
								elseif tempColorParts['mod'][colorPartIndex] == 'secondary' then
									secondaryColorIndex = 1
									ClearVehicleCustomSecondaryColour(vehPedIsIn)
								elseif tempColorParts['mod'][colorPartIndex] == 'pearlescent' then
									pearlColorIndex = 1
								end
					        end
						)
						if tempColorParts['mod'][colorPartIndex] == 'primary' then
							if Config.resprayTypes[1]['mod'][colorTypeIndex[1]] == "personalize" then
								RageUI.Slider(primaryCustomColorIndex[1]['label'] .. " [" .. primaryCustomColorIndex[1]['index'] .. "]", primaryCustomColorIndex[1]['index'], 255, "TEST", false, {}, true,
									function(Hovered, Selected, Active, Index)
										if (primaryCustomColorIndex[1]['index'] == 255 and Index == 1) or 
											(primaryCustomColorIndex[1]['index'] == 1 and Index == 255) then
											Index = 0
										end
										if primaryCustomColorIndex[1]['index'] ~= Index then
											primaryCustomColorIndex[1]['index'] = Index
											SetVehicleCustomPrimaryColour(vehPedIsIn, primaryCustomColorIndex[1]['index'], primaryCustomColorIndex[2]['index'], primaryCustomColorIndex[3]['index'])
											compareMods(_U('primaryRgbPaint'), 'customColorPrimary', -1, Index, calcModPrice(Config.colorParts['customPrimaryColorPrice']))
										end
									end
								)
								RageUI.Slider(primaryCustomColorIndex[2]['label'] .. " [" .. primaryCustomColorIndex[2]['index'] .. "]", primaryCustomColorIndex[2]['index'], 255, "TEST", false, {}, true,
									function(Hovered, Selected, Active, Index)
										if (primaryCustomColorIndex[2]['index'] == 255 and Index == 1) or 
											(primaryCustomColorIndex[2]['index'] == 1 and Index == 255) then
											Index = 0
										end
										if primaryCustomColorIndex[2]['index'] ~= Index then
											primaryCustomColorIndex[2]['index'] = Index
											SetVehicleCustomPrimaryColour(vehPedIsIn, primaryCustomColorIndex[1]['index'], primaryCustomColorIndex[2]['index'], primaryCustomColorIndex[3]['index'])
											compareMods(_U('primaryRgbPaint'), 'customColorPrimary', -1, Index, calcModPrice(Config.colorParts['customPrimaryColorPrice']))
										end
									end
								)
								RageUI.Slider(primaryCustomColorIndex[3]['label'] .. " [" .. primaryCustomColorIndex[3]['index'] .. "]", primaryCustomColorIndex[3]['index'], 255, "TEST", false, {}, true,
									function(Hovered, Selected, Active, Index)
										if (primaryCustomColorIndex[3]['index'] == 255 and Index == 1) or 
											(primaryCustomColorIndex[3]['index'] == 1 and Index == 255) then
											Index = 0
										end
										if primaryCustomColorIndex[3]['index'] ~= Index then
											primaryCustomColorIndex[3]['index'] = Index
											SetVehicleCustomPrimaryColour(vehPedIsIn, primaryCustomColorIndex[1]['index'], primaryCustomColorIndex[2]['index'], primaryCustomColorIndex[3]['index'])
											compareMods(_U('primaryRgbPaint'), 'customColorPrimary', -1, Index, calcModPrice(Config.colorParts['customPrimaryColorPrice']))
										end
									end
								)	
								RageUI.Slider(_U('primaryPaintFinish') .. " [" .. primaryPaintFinishIndex .. "]", primaryPaintFinishIndex, #Config.paintFinish, "", false, {}, true,
									function(Hovered, Selected, Active, Index)
										if primaryPaintFinishIndex ~= Index then
											primaryPaintFinishIndex = Index
											SetVehicleColours(vehPedIsIn, Config.paintFinish[primaryPaintFinishIndex], Config.paintFinish[secondaryPaintFinishIndex])
											compareMods(_U('primaryPaintFinish'), 'primaryPaintFinish', -1, Index, calcModPrice(Config.colorParts['primaryPaintFinishPrice']))
										end
									end
								)
							else
								RageUI.Slider(_U('primary') .. " [" .. primaryColorIndex .. "]", primaryColorIndex, #Config.colorPalette[colorTypeIndex[1]][Config.resprayTypes[1]['mod'][colorTypeIndex[1]]], "", false, {}, true,
									function(Hovered, Selected, Active, Index)
										if primaryColorIndex ~= Index then
											primaryColorIndex = Index
											SetVehicleColours(vehPedIsIn, Config.colorPalette[colorTypeIndex[1]][Config.resprayTypes[1]['mod'][colorTypeIndex[1]]][primaryColorIndex], Config.colorPalette[colorTypeIndex[2]][Config.resprayTypes[2]['mod'][colorTypeIndex[2]]][secondaryColorIndex])
											compareMods(_U('primary'), 'color1', -1, Index, calcModPrice(Config.colorParts['primaryColorPrice']))
										end
									end
								)
							end
						elseif tempColorParts['mod'][colorPartIndex] == 'secondary' then
							--ClearVehicleCustomSecondaryColour
							if Config.resprayTypes[2]['mod'][colorTypeIndex[2]] == "personalize" then
								RageUI.Slider(secondaryCustomColorIndex[1]['label'] .. " [" .. secondaryCustomColorIndex[1]['index'] .. "]", secondaryCustomColorIndex[1]['index'], 255, "TEST", false, {}, true,
									function(Hovered, Selected, Active, Index)
										if (secondaryCustomColorIndex[1]['index'] == 255 and Index == 1) or 
											(secondaryCustomColorIndex[1]['index'] == 1 and Index == 255) then
											Index = 0
										end
										if secondaryCustomColorIndex[1]['index'] ~= Index then
											secondaryCustomColorIndex[1]['index'] = Index
											SetVehicleCustomSecondaryColour(vehPedIsIn, secondaryCustomColorIndex[1]['index'], secondaryCustomColorIndex[2]['index'], secondaryCustomColorIndex[3]['index'])
											compareMods(_U('secondaryRgbPaint'), 'customColorSecondary', -1, Index, calcModPrice(Config.colorParts['customSecondaryColorPrice']))
										end
									end
								)
								RageUI.Slider(secondaryCustomColorIndex[2]['label'] .. " [" .. secondaryCustomColorIndex[2]['index'] .. "]", secondaryCustomColorIndex[2]['index'], 255, "TEST", false, {}, true,
									function(Hovered, Selected, Active, Index)
										if (secondaryCustomColorIndex[2]['index'] == 255 and Index == 1) or 
											(secondaryCustomColorIndex[2]['index'] == 1 and Index == 255) then
											Index = 0
										end
										if secondaryCustomColorIndex[2]['index'] ~= Index then
											secondaryCustomColorIndex[2]['index'] = Index
											SetVehicleCustomSecondaryColour(vehPedIsIn, secondaryCustomColorIndex[1]['index'], secondaryCustomColorIndex[2]['index'], secondaryCustomColorIndex[3]['index'])
											compareMods(_U('secondaryRgbPaint'), 'customColorSecondary', -1, Index, calcModPrice(Config.colorParts['customSecondaryColorPrice']))
										end
									end
								)
								RageUI.Slider(secondaryCustomColorIndex[3]['label'] .. " [" .. secondaryCustomColorIndex[3]['index'] .. "]", secondaryCustomColorIndex[3]['index'], 255, "TEST", false, {}, true,
									function(Hovered, Selected, Active, Index)
										if (secondaryCustomColorIndex[3]['index'] == 255 and Index == 1) or 
											(secondaryCustomColorIndex[3]['index'] == 1 and Index == 255) then
											Index = 0
										end
										secondaryCustomColorIndex[3]['index'] = Index
										SetVehicleCustomSecondaryColour(vehPedIsIn, secondaryCustomColorIndex[1]['index'], secondaryCustomColorIndex[2]['index'], secondaryCustomColorIndex[3]['index'])
										compareMods(_U('secondaryRgbPaint'), 'customColorSecondary', -1, Index, calcModPrice(Config.colorParts['customSecondaryColorPrice']))
									end
								)	
								RageUI.Slider(_U('secondaryPaintFinish') .. " [" .. secondaryPaintFinishIndex .. "]", secondaryPaintFinishIndex, #Config.paintFinish, "", false, {}, true,
									function(Hovered, Selected, Active, Index)
										secondaryPaintFinishIndex = Index
										if secondaryPaintFinishIndex ~= Index then
											SetVehicleColours(vehPedIsIn, Config.paintFinish[primaryPaintFinishIndex], Config.paintFinish[secondaryPaintFinishIndex])
											compareMods(_U('secondaryPaintFinish'), 'secondaryPaintFinish', -1, Index, calcModPrice(Config.colorParts['secondaryPaintFinishPrice']))
										end
									end
								)
							else
								RageUI.Slider(_U('secondary') .. " [" .. secondaryColorIndex .. "]", secondaryColorIndex, #Config.colorPalette[colorTypeIndex[2]][Config.resprayTypes[2]['mod'][colorTypeIndex[2]]], "", false, {}, true,
									function(Hovered, Selected, Active, Index)
										if secondaryColorIndex ~= Index then
											secondaryColorIndex = Index
											SetVehicleColours(vehPedIsIn, Config.colorPalette[colorTypeIndex[1]][Config.resprayTypes[1]['mod'][colorTypeIndex[1]]][primaryColorIndex], Config.colorPalette[colorTypeIndex[2]][Config.resprayTypes[2]['mod'][colorTypeIndex[2]]][secondaryColorIndex])
											compareMods(_U('secondary'), 'color2', -1, Index, calcModPrice(Config.colorParts['secondaryColorPrice']))
										end
									end
								)
							end
						elseif tempColorParts['mod'][colorPartIndex] == 'pearlescent' then
							RageUI.Slider(_U('pearlescent') .. " [" .. pearlColorIndex .. "]", pearlColorIndex, #Config.colorPalette[colorTypeIndex[3]][Config.resprayTypes[3]['mod'][colorTypeIndex[3]]], "", false, {}, true,
								function(Hovered, Selected, Active, Index)
									if pearlColorIndex ~= Index then
										pearlColorIndex = Index
										SetVehicleExtraColours(vehPedIsIn, Config.colorPalette[colorTypeIndex[3]][Config.resprayTypes[3]['mod'][colorTypeIndex[3]]][pearlColorIndex], Config.colorPalette[1]['metallic'][wheelColorIndex])
										compareMods(_U('pearlescent'), 'pearlescentColor', -1, Index, calcModPrice(Config.colorParts['pearlescentColorPrice']))
									end
								end
							)
						end
					elseif colorPartIndex == 4 then
						RageUI.List(_U('windows'),
							Config.resprayTypes[colorPartIndex]['label'], 
							windowTintIndex,
							'{Price}', 
							{}, 
							true, 
							function(Hovered, Active, Selected, Index)
							end,
							function(Index, CurrentItems)
					            local itemIndex = windowTintIndex - 2
								windowTintIndex = Index
								compareMods(Config.windowTints['label'], Config.windowTints['mod'], -1, itemIndex, calcModPrice(Config.windowTints['price']))
								SetVehicleWindowTint(vehPedIsIn, windowTintIndex - 2)
					        end
						)
					elseif tempColorParts['mod'][colorPartIndex] == 'wheels' then
						RageUI.Slider(_U('wheel_color') .. " (" .. (Config.colorPalette[8]['wheelPrice'] .. "$" or "---") .. ")",
							wheelColorIndex, #Config.colorPalette[1]['metallic'], "TEST", false, {}, true,
							function(Hovered, Selected, Active, Index)
								if wheelColorIndex ~= Index then
									wheelColorIndex = Index
									SetVehicleExtraColours(vehPedIsIn, Config.colorPalette[colorTypeIndex[3]][Config.resprayTypes[3]['mod'][colorTypeIndex[3]]][pearlColorIndex], Config.colorPalette[1]['metallic'][wheelColorIndex])
									compareMods(_U('wheel_color'), 'wheelColor', -1, Index, calcModPrice(Config.colorParts['wheelColorPrice']))
								end
							end
						)
					elseif tempColorParts['mod'][colorPartIndex] == 'tireSmoke' then 
						RageUI.Slider(smokeColorIndex[1]['label'] .. " [" .. smokeColorIndex[1]['index'] .. "]", smokeColorIndex[1]['index'], 255, "TEST", false, {}, true,
							function(Hovered, Selected, Active, Index)
								if (smokeColorIndex[1]['index'] == 255 and Index == 1) or 
									(smokeColorIndex[1]['index'] == 1 and Index == 255) then
									Index = 0
								end
								smokeColorIndex[1]['index'] = Index
								if vehModsOld['modSmokeEnabled'] then
									SetVehicleTyreSmokeColor(vehPedIsIn, smokeColorIndex[1]['index'], smokeColorIndex[2]['index'], smokeColorIndex[3]['index'])
									compareMods(Config.tireSmoke['label1'], Config.tireSmoke['mod1'], -1, Index, calcModPrice(Config.tireSmoke['price']))
								end
							end
						)
						RageUI.Slider(smokeColorIndex[2]['label'] .. " [" .. smokeColorIndex[2]['index'] .. "]", smokeColorIndex[2]['index'], 255, "TEST", false, {}, true,
							function(Hovered, Selected, Active, Index)
								if (smokeColorIndex[2]['index'] == 255 and Index == 1) or 
									(smokeColorIndex[2]['index'] == 1 and Index == 255) then
									Index = 0
								end
								smokeColorIndex[2]['index']= Index
								if vehModsOld['modSmokeEnabled'] then
									SetVehicleTyreSmokeColor(vehPedIsIn, smokeColorIndex[1]['index'], smokeColorIndex[2]['index'], smokeColorIndex[3]['index'])
									compareMods(Config.tireSmoke['label1'], Config.tireSmoke['mod1'], -1, Index, calcModPrice(Config.tireSmoke['price']))
								end
							end
						)
						RageUI.Slider(smokeColorIndex[3]['label'] .. " [" .. smokeColorIndex[3]['index'] .. "]", smokeColorIndex[3]['index'], 255, "TEST", false, {}, true,
							function(Hovered, Selected, Active, Index)
								if (smokeColorIndex[3]['index'] == 255 and Index == 1) or 
									(smokeColorIndex[3]['index'] == 1 and Index == 255) then
									Index = 0
								end
								smokeColorIndex[3]['index'] = Index
								if vehModsOld['modSmokeEnabled'] then
									SetVehicleTyreSmokeColor(vehPedIsIn, smokeColorIndex[1]['index'], smokeColorIndex[2]['index'], smokeColorIndex[3]['index'])
									compareMods(Config.tireSmoke['label1'], Config.tireSmoke['mod1'], -1, Index, calcModPrice(Config.tireSmoke['price']))
								end
							end
						)
					--[[elseif tempColorParts['mod'][colorPartIndex] == 'headlights' then
						RageUI.Slider(_U('headlights'),
							xenonColorIndex, #Config.xenon['items']['color'], "TEST", false, {}, true,
							function(Hovered, Selected, Active, Index)
								xenonColorIndex = Index
								if vehModsOld['modXenon'] then
									SetVehicleXenonLightsColour(vehPedIsIn, Config.xenon['items']['color'][xenonColorIndex])
									compareMods(Config.xenon['label1'], Config.xenon['mod1'], -1, Index, calcModPrice(Config.xenon['price']))
								end
							end
						)--]]
					end
				end, function()
					---Panels
				end
			)
			RageUI.IsVisible(neonMenu, true, true, true, function()
					RageUI.Checkbox(tempNeons[1]['label'] .. " (" .. (calcModPrice(tempNeons[1]['price']) .. "$" or "---") .. ")", 
						'{Price}', 
						neon1, 
						{ Style = RageUI.CheckboxStyle.Tick }, 
						function(Hovered, Selected, Active, Checked)
							if Active then
								neon1 = Checked and true or false
								SetVehicleNeonLightEnabled(vehPedIsIn, 0, neon1)
								compareMods(Config.neons[1]['label'], Config.neons[1]['mod'], -1, neon1, ((neon1 and vehModsOld['neonEnabled'][1]) or (not neon1 and vehModsOld['neonEnabled'][1])) and 0 or calcModPrice(tempNeons[1]['price']))
							end
						end
					)
					RageUI.Checkbox(tempNeons[2]['label'] .. " (" .. (calcModPrice(tempNeons[2]['price']) .. "$" or "---") .. ")", 
						'{Price}', 
						neon2, 
						{ Style = RageUI.CheckboxStyle.Tick }, 
						function(Hovered, Selected, Active, Checked)
							if Active then
								neon2 = Checked and true or false
								SetVehicleNeonLightEnabled(vehPedIsIn, 1, neon2)
								compareMods(Config.neons[2]['label'], Config.neons[2]['mod'], -1, neon2, ((neon2 and vehModsOld['neonEnabled'][3]) or (not neon2 and vehModsOld['neonEnabled'][3])) and 0 or calcModPrice(tempNeons[2]['price']))
							end
						end
					)
					RageUI.Checkbox(tempNeons[3]['label'] .. " (" .. (calcModPrice(tempNeons[3]['price']) .. "$" or "---") .. ")", 
						'{Price}', 
						neon3, 
						{ Style = RageUI.CheckboxStyle.Tick }, 
						function(Hovered, Selected, Active, Checked)
							if Active then
								neon3 = Checked and true or false
								SetVehicleNeonLightEnabled(vehPedIsIn, 2, neon3)
								compareMods(Config.neons[3]['label'], Config.neons[3]['mod'], -1, neon3, ((neon3 and vehModsOld['neonEnabled'][2]) or (not neon3 and vehModsOld['neonEnabled'][2])) and 0 or calcModPrice(tempNeons[3]['price']))
							end
						end
					)
					RageUI.Checkbox(tempNeons[4]['label'] .. " (" .. (calcModPrice(tempNeons[4]['price']) .. "$" or "---") .. ")", 
						'{Price}', 
						neon4, 
						{ Style = RageUI.CheckboxStyle.Tick }, 
						function(Hovered, Selected, Active, Checked)
							if Active then
								neon4 = Checked and true or false
								SetVehicleNeonLightEnabled(vehPedIsIn, 3, neon4)
								compareMods(Config.neons[4]['label'], Config.neons[4]['mod'], -1, neon4, ((neon4 and vehModsOld['neonEnabled'][4]) or (not neon4 and vehModsOld['neonEnabled'][4])) and 0 or calcModPrice(tempNeons[4]['price']))
							end
						end
					)

					if neon1 or neon2 or neon3 or neon4 then
						RageUI.Slider(neonIndex[1]['label'] .. " [" .. neonIndex[1]['index'] .. "]", neonIndex[1]['index'], 255, "TEST", false, {}, true,
							function(Hovered, Selected, Active, Index)
								if (neonIndex[1]['index'] == 255 and Index == 1) or 
									(neonIndex[1]['index'] == 1 and Index == 255) then
									Index = 0
								end
								if neonIndex[1]['index'] ~= Index then
									neonIndex[1]['index'] = Index
									SetVehicleNeonLightsColour(vehPedIsIn, neonIndex[1]['index'], neonIndex[2]['index'], neonIndex[3]['index'])
									if vehModsOld['neonEnabled'][1] or vehModsOld['neonEnabled'][2] or vehModsOld['neonEnabled'][3] or vehModsOld['neonEnabled'][4] then
										compareMods(Config.neons[5]['label'], Config.neons[5]['mod'], -1, Index, calcModPrice(Config.neons[5]['price']))
									end
								end
							end
						)
						RageUI.Slider(neonIndex[2]['label'] .. " [" .. neonIndex[2]['index'] .. "]", neonIndex[2]['index'], 255, "TEST", false, {}, true,
							function(Hovered, Selected, Active, Index)
								if (neonIndex[2]['index'] == 255 and Index == 1) or 
									(neonIndex[2]['index'] == 1 and Index == 255) then
									Index = 0
								end
								if neonIndex[2]['index'] ~= Index then
									neonIndex[2]['index']= Index
									SetVehicleNeonLightsColour(vehPedIsIn, neonIndex[1]['index'], neonIndex[2]['index'], neonIndex[3]['index'])
									if vehModsOld['neonEnabled'][1] or vehModsOld['neonEnabled'][2] or vehModsOld['neonEnabled'][3] or vehModsOld['neonEnabled'][4] then
										compareMods(Config.neons[5]['label'], Config.neons[5]['mod'], -1, Index, calcModPrice(Config.neons[5]['price']))
									end
								end
							end
						)
						RageUI.Slider(neonIndex[3]['label'] .. " [" .. neonIndex[3]['index'] .. "]", neonIndex[3]['index'], 255, "TEST", false, {}, true,
							function(Hovered, Selected, Active, Index)
								if (neonIndex[3]['index'] == 255 and Index == 1) or 
									(neonIndex[3]['index'] == 1 and Index == 255) then
									Index = 0
								end
								if neonIndex[3]['index'] ~= Index then
									neonIndex[3]['index'] = Index
									SetVehicleNeonLightsColour(vehPedIsIn, neonIndex[1]['index'], neonIndex[2]['index'], neonIndex[3]['index'])
									if vehModsOld['neonEnabled'][1] or vehModsOld['neonEnabled'][2] or vehModsOld['neonEnabled'][3] or vehModsOld['neonEnabled'][4] then
										compareMods(Config.neons[5]['label'], Config.neons[5]['mod'], -1, Index, calcModPrice(Config.neons[5]['price']))
									end
								end
							end
						)
					end
				end, function()
				---Panels
				end
			)
			RageUI.IsVisible(upgradeMenu, true, true, true, function()
					local menuItemCount = 0
					for i = 1, #tempUpgrades, 1 do
						local modCount = GetNumVehicleMods(vehPedIsIn, tempUpgrades[i]['modType'])
						--print(tempUpgrades[i]['mod'] .. ' modCount: ' .. modCount)
						local upgIndex = 1
						if tempUpgrades[i]['mod'] == 'modTurbo' then
							upgIndex = upgradeIndex[i][tempUpgrades[i]['mod']] and true or false
							local itemLabel = tempUpgrades[i]['label'] .. " (" .. (not upgIndex and (calcModPrice(tempUpgrades[i]['items']['price'][2]) or 0) .. "$" or "0$") .. ")"
							RageUI.Checkbox(itemLabel, 
								'{Price}', 
								upgIndex, 
								{ Style = RageUI.CheckboxStyle.Tick }, 
								function(Hovered, Selected, Active, Checked)
									if Active then
										upgradeIndex[i][tempUpgrades[i]['mod']] = Checked and true or false
										ToggleVehicleMod(vehPedIsIn, tempUpgrades[i]['modType'], upgradeIndex[i][tempUpgrades[i]['mod']])
										compareMods(tempUpgrades[i]['label'], tempUpgrades[i]['mod'], tempUpgrades[i]['modType'], upgradeIndex[i][tempUpgrades[i]['mod']], Checked and calcModPrice(tempUpgrades[i]['items']['price'][2]) or 0)
									end
								end
							)
							menuItemCount = menuItemCount + 1
						elseif modCount > 0 then
							upgIndex = upgradeIndex[i][tempUpgrades[i]['mod']]
							local itemLabel = tempUpgrades[i]['label'] .. " (" .. (calcModPrice(tempUpgrades[i]['items']['price'][upgIndex]) .. "$" or "---") .. ")"
							RageUI.List(itemLabel,
								tempUpgrades[i]['items']['label'], 
								upgIndex,
								'{Price}', 
								{}, 
								true, 
								function(Hovered, Active, Selected, Index)
									if upgradeIndex[i][tempUpgrades[i]['mod']] ~= Index and Index <= modCount + 1 then -- +1 para contar com o index da peça STOCK
										upgradeIndex[i][tempUpgrades[i]['mod']] = Index
										if Selected then
									
										end
									end
								end,
								function(Index, CurrentItems)
						            local itemIndex = Index - 2
						            SetVehicleMod(vehPedIsIn, tempUpgrades[i]['modType'], Index - 2, false)
						            compareMods(tempUpgrades[i]['label'], tempUpgrades[i]['mod'], tempUpgrades[i]['modType'], itemIndex, calcModPrice(tempUpgrades[i]['items']['price'][Index]))
						        end
							)
							menuItemCount = menuItemCount + 1
						end
					end
					if menuItemCount == 0 then
	            		RageUI.Button(_U('noStock') , _U('noStockTxt'), {
							LeftBadge = nil,
							RightBadge = nil,
							RightLabel = "Go back"
						}, true, function(Hovered, Active, Selected)
							if Selected then
								--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
							end
							if Hovered then
							-- My action the button is hovered by the mouse
							end
							if Active then
							-- My action the button is hightlighted
							end
						end, mainMenu)
	            	end
				end, function()
					---Panels
				end
			)
			RageUI.IsVisible(cartMenu, true, true, true, function()
				local menuItemCount = 0
				for k, v in pairs(shopCart) do 
					RageUI.Button(shopCart[k]['label'], "", {
							LeftBadge = nil,
							RightBadge = nil,
							RightLabel = shopCart[k]['price'] .. " $"
						}, not deleting, function(Hovered, Active, Selected)
							if Selected then
								--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
							end
							if Hovered then
							-- My action the button is hovered by the mouse
							end
							if Active then
							-- My action the button is hightlighted
								if IsControlJustReleased(0, 22) then
									if deleting then
										return
									end
									deleting = true
									DeleteFromCart(k, shopCart[k]['modType'])
								end
							end
					end)
					menuItemCount = menuItemCount + 1
				end
				if menuItemCount == 0 then
					RageUI.Button(_U('cartEmpty') , _U('cartEmptyTxt'), {
							LeftBadge = nil,
							RightBadge = nil,
							RightLabel = "Go back"
						}, true, function(Hovered, Active, Selected)
							if Selected then
								--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
							end
							if Hovered then
							-- My action the button is hovered by the mouse
							end
							if Active then
							-- My action the button is hightlighted
							end
						end, mainMenu)
				else
					RageUI.Slider(_U('shopProfit') .. " (" .. shopProfit .. "%)", shopProfit, 100, "", false, {}, true, 
						function(Hovered, Selected, Active, Index)
							if (shopProfit == 100 and Index == 1) or 
								(shopProfit == 1 and Index == 100) then
								Index = 0
							end
							if Index ~= shopProfit then
								shopProfit = Index
								calcCartValue()
							end
						end
					)
					RageUI.Button(_U('shopProfitTotal') , _U('shopProfitTotalTxt'), {
							LeftBadge = nil,
							RightBadge = nil,
							RightLabel = shopProfitValue .. " $"
						}, true, function(Hovered, Active, Selected)
							if Selected then
								--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
							end
							if Hovered then
							-- My action the button is hovered by the mouse
							end
							if Active then
							-- My action the button is hightlighted
							end
					end)
					RageUI.Button(_U('shopCosts') , _U('shopCostsTxt'), {
							LeftBadge = nil,
							RightBadge = nil,
							RightLabel = math.round(totalCartValue - shopProfitValue) .. " $"
						}, true, function(Hovered, Active, Selected)
							if Selected then
								--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
							end
							if Hovered then
							-- My action the button is hovered by the mouse
							end
							if Active then
							-- My action the button is hightlighted
							end
					end)
					RageUI.Button(_U('valueTotal') , _U('valueTotalPay'), {
							LeftBadge = nil,
							RightBadge = nil,
							RightLabel = totalCartValue .. " $"
						}, true, function(Hovered, Active, Selected)
							if Selected then
								--RageUI.Visible(bodyMenu, not RageUI.Visible(bodyMenu))
							end
							if Hovered then
							-- My action the button is hovered by the mouse
							end
							if Active then
							-- My action the button is hightlighted
							end
					end)
					RageUI.CenterButton(_U('finishPurchase') , "", {
							LeftBadge = nil,
							RightBadge = nil,
							RightLabel = nil
						}, not stop, function(Hovered, Active, Selected)
							if Selected then
								if stop then
									return
								end
								stop = true
								finishPurchase()
							end
							if Hovered then
							-- My action the button is hovered by the mouse
							end
							if Active then
							-- My action the button is hightlighted
							end
					end)
				end
				end, function()
					---Panels
				end
			)
		else
			vehPedIsIn = nil
			terminatePurchase()
		end
	end
end)

-- Create Blips
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(-211.04,  -1324.37,  30.89)

	SetBlipSprite (blip, 72)
	SetBlipDisplay(blip, 4)
	SetBlipColour (blip, 50)
	SetBlipScale  (blip, 1.0)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Wilkim's Custom's")
	EndTextCommandSetBlipName(blip)
end)

-- Prevent Free Tunning Bug
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if lsMenuIsShowed then
			DisableControlAction(2, 288, true)
			DisableControlAction(2, 289, true)
			DisableControlAction(2, 170, true)
			DisableControlAction(2, 167, true)
			DisableControlAction(2, 168, true)
			DisableControlAction(2, 23, true)
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		else
			Citizen.Wait(500)
		end
	end
end)

RegisterNetEvent('fpwn_customs:cantBill')
AddEventHandler('fpwn_customs:cantBill', function(amount, targetId)
	terminatePurchase()
end)

RegisterNetEvent('fpwn_customs:canBill')
AddEventHandler('fpwn_customs:canBill', function(amount, targetId)
	TriggerServerEvent('esx_billing:sendBill', targetId, society, _U('mechanic'), amount)
	terminatePurchase()
end)

RegisterNetEvent('fpwn_customs:resetVehicle')
AddEventHandler('fpwn_customs:resetVehicle', function(vehProps)
	ClearVehicleCustomPrimaryColour(vehPedIsIn)
	ClearVehicleCustomSecondaryColour(vehPedIsIn)
	ESX.Game.SetVehicleProperties(vehPedIsIn, vehProps)
	terminatePurchase()
end)

RegisterNetEvent('fpwn_customs:getVehicle')
AddEventHandler('fpwn_customs:getVehicle', function()
	TriggerServerEvent('fpwn_customs:refreshOwnedVehicle', ESX.Game.GetVehicleProperties(vehPedIsIn))
end)