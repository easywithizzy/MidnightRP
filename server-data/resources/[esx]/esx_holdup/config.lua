Config = {}
Config.Locale = 'en'

Config.Marker = {
	r = 250, g = 0, b = 0, a = 100,  -- red color
	x = 1.0, y = 1.0, z = 1.5,       -- tiny, cylinder formed circle
	DrawDistance = 15.0, Type = 1    -- default circle type, low draw distance due to indoors area
}

Config.PoliceNumberRequired = 2
Config.TimerBeforeNewRob    = 1800 -- The cooldown timer on a store after robbery was completed / canceled, in seconds

Config.MaxDistance    = 10   -- max distance from the robbary, going any longer away from it will to cancel the robbary
Config.GiveBlackMoney = true -- give black money? If disabled it will give cash instead

Stores = {
	["paleto_twentyfourseven"] = {
		position = { x = 1727.6135253906, y = 6415.279296875, z = 35.037261962891 },
		reward = math.random(5000, 35000),
		nameOfStore = "24/7. (Paleto Bay)",
		secondsRemaining = 70, -- seconds
		lastRobbed = 0
	},
	["sandyshores_twentyfoursever"] = {
		position = { x = 1959.855712, y = 3739.849609375, z = 32.3437 },
		reward = math.random(3000, 20000),
		nameOfStore = "24/7. (Sandy Shores)",
		secondsRemaining = 60, -- seconds
		lastRobbed = 0
	},
	["littleseoul_twentyfourseven"] = {
		position = { x = -706.02301, y = -913.4946, z = 19.2155 },
		reward = math.random(3000, 20000),
		nameOfStore = "24/7. (Little Seoul)",
		secondsRemaining = 60, -- seconds
		lastRobbed = 0
	},
	["ocean_liquor"] = {
		position = { x = -2966.045166, y = 390.78869, z = 15.04331 },
		reward = math.random(3000, 30000),
		nameOfStore = "Robs Liquor. (Great Ocean Highway)",
		secondsRemaining = 60, -- seconds
		lastRobbed = 0
	},
	["rancho_liquor"] = {
		position = { x = 1133.7900390, y = -982.45190, z = 46.41584 },
		reward = math.random(3000, 50000),
		nameOfStore = "Robs Liquor. (El Rancho Blvd)",
		secondsRemaining = 60, -- seconds
		lastRobbed = 0
	},
	["sanandreas_liquor"] = {
		position = { x = -1221.82995, y = -908.56787, z = 12.32635 },
		reward = math.random(3000, 30000),
		nameOfStore = "Robs Liquor. (San Andreas Avenue)",
		secondsRemaining = 60, -- seconds
		lastRobbed = 0
	},
	["grove_ltd"] = {
		position = { x = -46.4081, y = -1758.1828, z = 29.42099 },
		reward = math.random(3000, 15000),
		nameOfStore = "LTD Gasoline. (Grove Street)",
		secondsRemaining = 60, -- seconds
		lastRobbed = 0
	},
	["clinton_247"] = {
		position = { x = 372.219772, y = 326.49658, z = 103.566421 },
		reward = math.random(3000, 15000),
		nameOfStore = "24/7. (Clinton Ave)",
		secondsRemaining = 60, -- seconds
		lastRobbed = 0
	},
	["prosperity_liquor"] = {
		position = { x = -1485.9311, y = -377.7034, z = 40.16339 },
		reward = math.random(3000, 30000),
		nameOfStore = "Robs Liquor. (Prosperity St)",
		secondsRemaining = 60, -- seconds
		lastRobbed = 0
	},
	["palominofwy_247"] = {
		position = { x = 2557.22680, y = 380.53054, z = 108.62294 },
		reward = math.random(3000, 15000),
		nameOfStore = "24/7. (Palomino Fwy)",
		secondsRemaining = 60, -- seconds
		lastRobbed = 0
	},
	["route68_liquor"] = {
		position = { x = 1166.00463, y = 2711.03369, z = 38.1577 },
		reward = math.random(3000, 30000),
		nameOfStore = "Robs Liquor. (Route 68)",
		secondsRemaining = 60, -- seconds
		lastRobbed = 0
	},
	["route68_247"] = {
		position = { x = 549.263305, y = 2671.35400, z = 42.1564 },
		reward = math.random(3000, 15000),
		nameOfStore = "24/7. (Route 68)",
		secondsRemaining = 60, -- seconds
		lastRobbed = 0
	},
	["senorafwy_247"] = {
		position = { x = 2677.87255, y = 3279.1120, z = 55.2411 },
		reward = math.random(3000, 15000),
		nameOfStore = "24/7. (Senora Fwy)",
		secondsRemaining = 60, -- seconds
		lastRobbed = 0
	},
	["ineseno_247"] = {
		position = { x = -3038.86132, y = 584.34027, z = 7.9089 },
		reward = math.random(3000, 15000),
		nameOfStore = "24/7. (Ineseno Road)",
		secondsRemaining = 60, -- seconds
		lastRobbed = 0
	},
	["barbareno_247"] = {
		position = { x = -3242.32641, y = 999.74609, z = 12.83071 },
		reward = math.random(3000, 15000),
		nameOfStore = "24/7. (Barbareno Rd)",
		secondsRemaining = 60, -- seconds
		lastRobbed = 0
	},
	["grapeseed_ltd"] = {
		position = { x = 1697.8297, y = 4922.67480, z = 42.0636 },
		reward = math.random(3000, 15000),
		nameOfStore = "LTD Gasoline. (Grove Street)",
		secondsRemaining = 60, -- seconds
		lastRobbed = 0
	},
	["banham_ltd"] = {
		position = { x = -1819.9837, y = 794.4307, z = 138.08407 },
		reward = math.random(3000, 15000),
		nameOfStore = "LTD Gasoline. (Banham Canyon Dr)",
		secondsRemaining = 60, -- seconds
		lastRobbed = 0
	},
	["algonquin_liquor"] = {
		position = { x = 1392.79821, y = 3606.7587, z = 34.9809 },
		reward = math.random(3000, 30000),
		nameOfStore = "Ace Liquor. (Algonquin Blvd)",
		secondsRemaining = 60, -- seconds
		lastRobbed = 0
	},
	["mirror_ltd"] = {
		position = { x = 1164.9434, y = -322.5929, z = 69.20507 },
		reward = math.random(3000, 15000),
		nameOfStore = "LTD Gasoline. (Mirror Park Boulevard)",
		secondsRemaining = 60, -- seconds
		lastRobbed = 0
	}
}
