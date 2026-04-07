while true do
	if ~turtle.down() then
		turtle.digDown()
		term.write(turtle.getFuelLevel())
	end
end
