local skynet = require "skynet"
local utils = require "utils"

local max_client = 64

skynet.start(function()
	skynet.error("Server start")
	skynet.newservice("console")
	skynet.newservice("debug_console",8000)

	local watchdog = skynet.newservice("watchdog")
	skynet.call(watchdog, "lua", "start", {
		port = 8888,
		maxclient = max_client,
		nodelay = true,
	})
	skynet.error("Watchdog listen on", 8888)

	skynet.newservice("pbc")
	
	local service_db = skynet.newservice("mongodb")
	skynet.send(service_db, "lua", "init")

	local service_hall = skynet.newservice("hall")
	skynet.call(service_hall, "lua", "start")

	skynet.exit()
end)
