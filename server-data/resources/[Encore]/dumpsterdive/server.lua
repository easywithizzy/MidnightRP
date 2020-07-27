ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local dumpsterItems = {
    [1] = {chance = 12, id = 'pAmmo', name = 'Pistol Ammo', quantity = 1, limit = 2},
    [2] = {chance = 2, id = 'bottle', name = '50cl Water bottle', quantity = 1, limit = 10},
    [3] = {chance = 12, id = 'wallet', name = 'Wallet', quantity = 1, limit = 5},
}

ESX.RegisterUsableItem('wallet', function(source) 
    local source = tonumber(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local cash = math.random(20, 120)
    local chance = math.random(1,2)

    if chance == 2 then
        TriggerClientEvent('esx:showNotification', source, 'You find $' .. cash .. ' inside the wallet')
        xPlayer.addMoney(cash)
        local cardChance = math.random(1, 40)
        if cardChance == 20 then
            TriggerClientEvent('esx:showNotification', source, 'You find a Green Keycard inside the wallet')
            xPlayer.addInventoryItem('green-keycard', 1)
        end
    else
        TriggerClientEvent('esx:showNotification', source, 'The wallet was empty')
    end

    xPlayer.removeInventoryItem('wallet', 1)
end)

RegisterServerEvent('onyx:startDumpsterTimer')
AddEventHandler('onyx:startDumpsterTimer', function(dumpster)
    startTimer(source, dumpster)
end)

RegisterServerEvent('onyx:giveDumpsterReward')
AddEventHandler('onyx:giveDumpsterReward', function()
    local source = tonumber(source)
    local item = {}
    local xPlayer = ESX.GetPlayerFromId(source)
    local gotID = {}
    local rolls = math.random(1, 2)
    local foundItem = false

    for i = 1, rolls do
        item = dumpsterItems[math.random(1, #dumpsterItems)]
        if math.random(1, 10) >= item.chance then
            if item.isWeapon and not gotID[item.id] then
                if item.limit > 0 then
                    local count = xPlayer.getInventoryItem(item.id).count
                    if count >= item.limit then
                        TriggerClientEvent('esx:showNotification', source, 'You find a ' .. item.name .. ' but cannot carry any more of this item')
                    else
                        gotID[item.id] = true
                        TriggerClientEvent('esx:showNotification', source, 'You find a ' .. item.name)
                        foundItem = true
                        xPlayer.addWeapon(item.id, 50)
                    end
                else
                    gotID[item.id] = true
                    TriggerClientEvent('esx:showNotification', source, 'You find a ' .. item.name)
                    foundItem = true
                    xPlayer.addWeapon(item.id, 50)
                end
            elseif not gotID[item.id] then
                if item.limit > 0 then
                    local count = xPlayer.getInventoryItem(item.id).count
                    if count >= item.limit then
                        TriggerClientEvent('esx:showNotification', source, 'You find ' .. item.quantity .. 'x ' .. item.name .. ' but cannot carry any more of this item')
                    else
                        gotID[item.id] = true
                        TriggerClientEvent('esx:showNotification', source, 'You find ' .. item.quantity .. 'x ' .. item.name)
                        xPlayer.addInventoryItem(item.id, item.quantity)
                        foundItem = true
                    end
                else
                    gotID[item.id] = true
                    TriggerClientEvent('esx:showNotification', source, 'You find ' .. item.quantity .. 'x ' .. item.name)
                    xPlayer.addInventoryItem(item.id, item.quantity)
                    foundItem = true
                end
            end
        end
        if i == rolls and not gotID[item.id] and not foundItem then
            TriggerClientEvent('esx:showNotification', source, 'You find nothing')
        end
    end
end)

function startTimer(id, object)
    local timer = 10 * 60000

    while timer > 0 do
        Wait(1000)
        timer = timer - 1000
        if timer == 0 then
            TriggerClientEvent('onyx:removeDumpster', id, object)
        end
    end
end