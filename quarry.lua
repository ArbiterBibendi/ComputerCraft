while true do
	if turtle.down() == false then
		turtle.digDown()
		term.write(turtle.getFuelLevel())
	end
end
