local utils = require "utils"
local skynet = require "skynet"

local M = {}

function M.pack(name, msg, session)
	local buf = skynet.call("pbc", "lua", "encode", name, msg)
	local data = skynet.call("pbc","lua","encode","Msg.MsgBase",{name=Msg.MsgBase,data = buf,session = session})
	local len = string.len(data)
	local f = string.format("> i2 c%d", len)
	return string.pack(f, data)
end

function M.unpack(data)
	utils.print(data)
	local len = string.len(data)
	local f = string.format("> c%d", len)
	local buf = string.unpack(f, data)
	utils.hex(buf)
	local msgbase = skynet.call("pbc", "lua", "decode", "Msg.MsgBase", buf)
	utils.print(msgbase)
	local msg = skynet.call("pbc", "lua", "decode", msgbase.name, msgbase.data)
	return msgbase.name, msg, msgbase.session
end

return M
