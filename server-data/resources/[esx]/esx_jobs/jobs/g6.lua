Config.Jobs.g6 = {

	BlipInfos = {
		Sprite = 436,
		Color = 5
	},

	Vehicles = {

		Truck = {
			Spawner = 1,
            Hash = 'rumpo',
            Trailer = 'none',
            HasCaution = true
		}

	},

	Zones = {

		CloakRoom = {
			Pos = {x = -195.57, y =  -829.71, z = 30.01},
			Size = {x = 3.0, y = 3.0, z = 2.0},
			Color = {r = 204, g = 204, b = 0},
			Marker = 1,
			Blip = true,
			Name = _U('deilivery'),
			Type = 'cloakroom',
			Hint = _U('cloak_change'),
			GPS = {x = -195.57, y = -829.71, z = 30.01}
		},

		VehicleSpawner = {
			Pos = {x = -114.41, y = -888.32, z = 28.27},
			Size = {x = 3.0, y = 3.0, z = 2.0},
			Color = {r = 255, g = 213, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U('spawn_veh'),
			Type = 'vehspawner',
			Spawner = 1,
			Hint = _U('spawn_rumpo_button'),
			Caution = 2000,
			GPS = {x = -114.41, y = -888.32, z = 28.27}
		},

		VehicleSpawnPoint = {
			Pos = {x = -114.41, y = -888.32, z = 28.27},
			Size = {x = 3.0, y = 3.0, z = 1.0},
			Marker = -1,
			Blip = false,
			Name = _U('service_vh'),
			Type = 'vehspawnpt',
			Spawner = 1,
			GPS = 0,
			Heading = 0
		},

		VehicleDeletePoint = {
			Pos = {x = 520.68, y = -2124.21, z = 4.98},
			Size = {x = 5.0, y = 5.0, z = 1.0},
			Color = {r = 255, g = 0, b = 0},
			Marker = 1,
			Blip = false,
			Name = _U('return_vh'),
			Type = 'vehdelete',
			Hint = _U('return_vh_button'),
			Spawner = 1,
			Caution = 2000,
			GPS = 0,
			Teleport = 0
		},

		Delivery = {
			Pos = {x = 491.40, y = -2163.37, z = 4.91},
			Color = {r = 204, g = 204, b = 0},
			Size = {x = 10.0, y = 10.0, z = 1.0},
			Marker = 1,
			Blip = true,
			Name = _U('f_deliver_gas'),
			Type = 'delivery',
			Spawner = 1,
			Item = {
				{
					name = _U('delivery'),
					time = 0.5,
					remove = 1,
					max = 100, -- if not present, probably an error at itemQtty >= item.max in esx_jobs_sv.lua
					price = 61,
					requires = 'essence',
					requires_name = _U('f_gas'),
					drop = 100
				}
			},

			Hint = _U('f_deliver_gas_button'),
			GPS = {x = 609.58, y = 2856.74, z = 39.49}
		}

	}
}
