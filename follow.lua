if arg[1] == nil then
	print("Usage: follow [player]")
	shell.exit()
end
local strings = require("cc.strings")

local x, y, z = gps.locate()
local direction = 0
local DIR_FORWARD, DIR_RIGHT, DIR_BACKWARD, DIR_LEFT = 0, 1, 2, 3
local height = 3

-- calibrate direction
print("Calibrating direction")
turtle.forward()
local cx, cy, cz = gps.locate()
if cx < x then
	direction = DIR_RIGHT
elseif cx > x then
	direction = DIR_LEFT
elseif cz < z then
	direction = DIR_BACKWARD
elseif cz > z then
	direction = DIR_FORWARD
elseif cz == z and cx == x then
	print("Turtle can not move")
	return
end
turtle.back()

function face(dir)
	if direction == DIR_LEFT and dir == DIR_FORWARD then
		turtle.turnRight()
		direction = dir
		return
	elseif direction == DIR_FORWARD and dir == DIR_LEFT then
		turtle.turnLeft()
		direction = dir
		return
	end
	while direction < dir do
		turtle.turnRight()
		direction = direction + 1
	end
	while direction > dir do
		turtle.turnLeft()
		direction = direction - 1
	end
	if direction > 3 then
		print("resetting direction")
		direction = 0
	end
end

local username = arg[1]
local modem = peripheral.find("modem")
modem.open(1337)

while true do
	modem.transmit(1337, 1337, "get_player_pos " .. username)
	local _, _, channel, _, message, _ = os.pullEvent("modem_message")
	if channel ~= 1337 then
		goto continue
	end
	local split_message = strings.split(message, " ")
	if split_message[1] == "player_pos_error" then
		print(split_message[2])
		return
	elseif split_message[1] == "player_pos" then
		local px = tonumber(split_message[3])
		local py = tonumber(split_message[4])
		local pz = tonumber(split_message[5])
		print(string.format("%s: %d, %d, %d", username, px, py, pz))
		x, y, z = gps.locate()

		if y < py + height then
			turtle.up()
		elseif y > py + height then
			turtle.down()
		end
		if z < pz then
			face(DIR_FORWARD)
			turtle.forward()
		elseif z > pz then
			face(DIR_BACKWARD)
			turtle.forward()
		elseif x < px then
			face(DIR_LEFT)
			turtle.forward()
		elseif x > px then
			face(DIR_RIGHT)
			turtle.forward()
		end
	end
	::continue::
end
