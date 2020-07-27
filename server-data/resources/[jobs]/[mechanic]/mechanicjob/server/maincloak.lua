ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('mrv_shops:giveItem')
AddEventHandler('mrv_shops:giveItem', function(item, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerMoney = xPlayer.getMoney()

    if playerMoney >= item.Price * count then
        xPlayer.addInventoryItem(item.Value, count)
        xPlayer.removeMoney(item.Price * count)

        xPlayer.showNotification(_U('you_bought') .. count .. ' ' .. item.Label .. '~s~ ' .. _U('for') .. ' ~g~' .. item.Price * count .. '$')
    else
        xPlayer.showNotification(_U('not_enough') .. '~g~' .. item.Label .. '~s~' .. _U('missing') .. '~g~' .. item.Price * count - playerMoney .. '$')
    end
end)