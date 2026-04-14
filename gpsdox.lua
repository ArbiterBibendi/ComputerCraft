print("Running Player GPS Server")
local strings = require("cc.strings")
local modem = peripheral.find("modem")
local player_detector = peripheral.find("player_detector")
local PORT = 1337
modem.open(PORT)
while true do
	_, _, _, _, message, distance = os.pullEvent("modem_message")
	local split_message = strings.split(message, " ")
	local message_type = split_message[1]
	local username = split_message[2]
	if message_type == "get_player_pos" then
		local player_pos = player_detector.getPlayerPos(username)
		if player_pos == nil then
			print("Player not found")
			modem.transmit(PORT, PORT, "player_pos_error PlayerNotFound")
			goto continue
		end
		if player_pos.dimension ~= "minecraft:overworld" then
			print("Player not in overworld")
			modem.transmit(PORT, PORT, "player_pos_error PlayerNotInOverworld")
			goto continue
		end
		local x, y, z = player_pos.x, player_pos.y, player_pos.z
		modem.transmit(PORT, PORT, string.format("player_pos %s %d %d %d", username, x, y, z))
	end
	::continue::
end
