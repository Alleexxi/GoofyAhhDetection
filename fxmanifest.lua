fx_version 'cerulean'
games { 'rdr3', 'gta5' }

author 'viewmatrix'
description 'Illegal Native Execution detected!!1!11!'
version '1.0.0'

lua54 'yes'


shared_scripts {
  "config.lua"
}

client_scripts {
  "client/import.lua",
  "client/main.lua"
}

server_scripts {
  "install.js",
  "server/main.lua",
}
