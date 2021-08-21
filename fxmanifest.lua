fx_version 'adamant'
game 'gta5'
name 'Fika_Hud'
description 'Uncluttered fonctionnal UI, made to remplace the framework\'s usual base UI (Fork of Kl_HudV2 UI).'
ui_page 'html/ui.html'
author 'thibaultDup'

--MODIFIED
files {
    'html/ui.html',
    'html/script.js',
    'html/main.css',
}

--MODIFIED
shared_scripts {
	'@es_extended/imports.lua',
    'config/config.lua',
}

client_scripts {
    'client/client.lua',
}

server_scripts {
	'server/server.lua',
}