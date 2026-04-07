local x, y, z = 0, 0, 0
local qx, qy, qz = 4, 4, 4

while (turtle.getFuelLevel() - 1) + y >= 0 do
	if turtle.down() == false then
		turtle.digDown()
		term.write(turtle.getFuelLevel())
	end
	y = y - 1
end

while y < 0 do
	turtle.up()
end
