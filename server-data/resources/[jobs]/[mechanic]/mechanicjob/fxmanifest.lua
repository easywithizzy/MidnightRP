fx_version 'adamant'

game 'gta5'

description 'Wilkims Customs'

version '1.0.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/fr.lua',
	'locales/pl.lua',
	'locales/br.lua',
	'locales/de.lua',
	'config.lua',
	'functions.lua',
	'server/main.lua',
	'server/maincloak.lua'
}

client_scripts {
	"src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/panels/*.lua",
	"src/menu/windows/*.lua",
	
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/fr.lua',
	'locales/pl.lua',
	'locales/br.lua',
	'locales/de.lua',
	'config.lua',
	'functions.lua',
	'client/main.lua',
	'client/maincloak.lua',
	'client/menu.lua',
	'client/menu.lua'
}
