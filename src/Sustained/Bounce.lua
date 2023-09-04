-- makes the camera go up and down continously
return function(effectsPart, speed, maxHeight)
	speed = tonumber(speed) or 1 -- the speed with which the camera goes up and down (higher = faster)
	maxHeight = tonumber(maxHeight) or 2 -- how much the camera goes up and down (maximum increase in height, 
						-- both positive and negative)
	local humanoid = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
	return function()
		local now = os.clock()
		local height = math.sin(now * speed) * maxHeight
		effectsPart.Offset = Vector3.new(0, height, 0)
	end
end