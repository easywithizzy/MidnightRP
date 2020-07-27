ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('mrv_shops:giveItem')
AddEventHandler('mrv_shops:giveItem', function(item, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerMoney = xPlayer.getMoney()

    if playerMoney >= item.Price * count then
        xPlayer.removeMoney(item.Price * count)
        xPlayer.addInventoryItem(item.Value, count)

        xPlayer.showNotification('for' .. count .. ' ' .. item.Label .. '~s~ ' .. _U('for') .. ' ~g~' .. item.Price * count .. '$')
    else
        xPlayer.showNotification('test' .. '~g~' .. item.Label .. '~s~' .. _U('missing') .. '~g~' .. item.Price * count - playerMoney .. '$')
    end
end)