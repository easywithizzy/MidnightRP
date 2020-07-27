local ESX = nil

TriggerEvent("esx:getSharedObject", function(obj) 
    ESX = obj 
end)

RegisterServerEvent("esx-ecobottles:sellBottles")
AddEventHandler("esx-ecobottles:sellBottles", function()
    local player = ESX.GetPlayerFromId(source)

    local currentBottles = player.getInventoryItem("bottle")["count"]
    
    if currentBottles > 0 then
        math.randomseed(os.time())
        local randomMoney = math.random((Config.BottleReward[1] or 1), (Config.BottleReward[2] or 4))

        player.removeInventoryItem("bottle", currentBottles)
        player.addMoney(randomMoney * currentBottles)

        TriggerClientEvent("esx:showNotification", source, ("You sold %s bottle and got paid $%s."):format(currentBottles, currentBottles * randomMoney))
    else
        TriggerClientEvent("esx:showNotification", source, "You don't have any bottles to sell.")
    end
end)