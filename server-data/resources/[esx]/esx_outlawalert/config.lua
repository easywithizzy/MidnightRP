Config = {}

Config.Locale = 'en'

-- Set the time (in minutes) during the player is outlaw
Config.Timer = 1

-- Set if show alert when player use gun
Config.GunshotAlert = true

-- Set if show when player do carjacking
Config.CarJackingAlert = true

-- Set if show when player fight in melee
Config.MeleeAlert = false

-- In seconds
Config.BlipGunTime = 120

-- Blip radius, in float value!
Config.BlipGunRadius = 40.0

-- In seconds
Config.BlipMeleeTime = 0

-- Blip radius, in float value!
Config.BlipMeleeRadius = 25.0

-- In seconds
Config.BlipJackingTime = 60

-- Blip radius, in float value!
Config.BlipJackingRadius = 40.0

-- Show notification when cops steal too?
Config.ShowCopsMisbehave = true

-- Jobs in this table are considered as cops
Config.WhitelistedCops = {
	'police',
	'ambulance'
}