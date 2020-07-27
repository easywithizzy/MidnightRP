 Citizen.CreateThread(function()
    while true do
        local player = GetPlayerPed(-1)
        Citizen.Wait(5*1000)
        
        SetDiscordAppId(714880081314709574)

        
        --SetRichPresence( GetPlayerName ( source ) .. " is on " .. GetStreetNameFromHashKey( GetStreetNameAtCoord ( table.unpack( GetEntityCoords ( player ) ) ) )  )

        SetDiscordRichPresenceAsset("crownlogo")
        SetDiscordRichPresenceAssetText(GetPlayerName( source ) )

        SetDiscordRichPresenceAssetSmall("crown96x96.png")
        SetDiscordRichPresenceAssetText("Join Our Discord: https://discord.gg/PAZcb5f")

     end
 end)