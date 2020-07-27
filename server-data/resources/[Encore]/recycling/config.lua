Config = {}

Config.BottleRecieve = { 1, 3 } -- This is the math random ex. math.random(1, 6) this will give you 1 - 6 bottles when searching a bin.
Config.BottleReward = { 1, 4 } -- This is the math random ex. math.random(1, 4) this will give a random payout between 1 - 4

-- Here you add all the bins you are going to search.
Config.BinsAvailable = {
    "prop_bin_01a",
    "prop_bin_03a",
    "prop_bin_05a"
}

-- This is where you add the locations where you sell the bottles.
Config.SellBottleLocations = {
    vector3(388.30194091797, -874.88238525391, 29.295169830322),
    vector3(793.8789, -735.6322, 27.9674),
    vector3(-428.81112, -1728.1811, 19.7838),
    vector3(-1182.5546, -1248.1556, 6.9915)
}