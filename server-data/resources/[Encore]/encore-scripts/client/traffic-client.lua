Citizen.CreateThread(function()
	while true do

	-- These natives has to be called every frame.

    		SetVehicleDensityMultiplierThisFrame(0.3)
		SetPedDensityMultiplierThisFrame(0.4)
		SetRandomVehicleDensityMultiplierThisFrame(0.1)
		SetParkedVehicleDensityMultiplierThisFrame(0.0)
		SetScenarioPedDensityMultiplierThisFrame(0.1, 0.1)

		-- These natives do not have to be called everyframe.
		SetGarbageTrucks(0)
		SetRandomBoats(0)

           
	RemoveAllPickupsOfType(0xDF711959) -- carbine rifle
    RemoveAllPickupsOfType(0xF9AFB48F) -- pistol
    RemoveAllPickupsOfType(0xA9355DCD) -- pumpshotgun
	
	Citizen.Wait(0)
	end
end)