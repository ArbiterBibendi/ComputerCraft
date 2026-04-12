local DIR_FORWARD, DIR_RIGHT, DIR_BACKWARD, DIR_LEFT = 0, 1, 2, 3
local x, y, z = 0, 0, 0
local qx, qy, qz = 3, 3, 3
local direction = 0

function face(dir)
	while direction ~= dir do
		turtle.turnRight()
		direction = direction + 1
		if direction > 3 then
			direction = 0
		end
	end
end

function forward()
	if turtle.forward() == false then
		turtle.dig()
		forward()
	else
		if direction == DIR_FORWARD then
			z = z + 1
		elseif direction == DIR_BACKWARD then
			z = z - 1
		elseif direction == DIR_LEFT then
			x = x - 1
		elseif direction == DIR_RIGHT then
			x = x + 1
		end
	end
end
function down()
	if turtle.down() == false then
		turtle.digDown()
		down()
	else
		y = y - 1
	end
end
function turtleReturn()
	while y < 0 do -- turtle only goes down
		turtle.up()
		y = y + 1
	end

	local direction_x = x / math.abs(x)
	local direction_z = z / math.abs(z)

	while x ~= 0 do
		if direction_x == -1 then
			face(DIR_RIGHT)
		elseif direction_x == 1 then
			face(DIR_LEFT)
		end
		forward()
	end
	while z ~= 0 do
		if direction_z == -1 then
			face(DIR_FORWARD)
		elseif direction_z == 1 then
			face(DIR_BACKWARD)
		end
		forward()
	end
end

function checkFuel()
	if (turtle.getFuelLevel() - 10) - (math.abs(x) + math.abs(y) + math.abs(z)) >= 0 then
		return true
	end
	return false
end

local direction_to_mine_z, direction_to_mine_x = DIR_FORWARD, DIR_RIGHT

function mineX()
	face(direction_to_mine_x)
	forward()
end
function mineZ()
	face(direction_to_mine_z)
	forward()
end
function swapX()
	if direction_to_mine_x == DIR_RIGHT then
		direction_to_mine_x = DIR_LEFT
	else
		direction_to_mine_x = DIR_RIGHT
	end
end
function swapZ()
	if direction_to_mine_z == DIR_FORWARD then
		direction_to_mine_z = DIR_BACKWARD
	else
		direction_to_mine_z = DIR_FORWARD
	end
end

down()
for i = 1, qy do
	for j = 1, qz do
		for k = 1, qx - 1 do
			mineX()
			if checkFuel() == false then
				turtleReturn()
				break
			end
		end
		swapX()
		if j < qz then
			mineZ()
			if checkFuel() == false then
				turtleReturn()
				break
			end
		end
	end
	swapZ()
	if i < qy then
		down()
		if checkFuel() == false then
			turtleReturn()
			break
		end
	end
end

turtleReturn()
