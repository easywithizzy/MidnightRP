RMenu.Add('showcase', 'shopMenu', RageUI.CreateMenu("Sport Shop", 'A shop full of wonders'))
RMenu:Get('showcase', 'shopMenu').EnableMouse = false

local function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

local index = {
    items = 1
}

local actualPrice = 0

RageUI.CreateWhile(1.0, function()
    if RageUI.Visible(RMenu:Get('showcase', 'shopMenu')) then
        RageUI.DrawContent({ header = true, glare = true, instructionalButton = true }, function()

            for k, v in pairs(MRV_Shops_Config.Items) do
                RageUI.List(v.Label .. ' ('.. _U('price') .. ' : ' .. v.Price .. '$)', Numbers, index.items, nil, { }, true, function(hovered, active, selected, Index)
                    index.items = Index

                    if selected then
                        local item = v.Value
                        local count = Numbers[Index]
                        local price = v.Price * count

                        TriggerServerEvent('mrv_shops:giveItem', v, count)
                    end
                end)
            end

        end, function()
        end)
    end
end, 1)