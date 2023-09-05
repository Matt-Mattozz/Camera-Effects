-- makes the camera go up and down continously
return function(speed, maxHeight)
	speed = tonumber(speed) or 1 -- the speed with which the camera goes up and down (higher = faster)
	maxHeight = tonumber(maxHeight) or 2 -- how much the camera goes up and down (maximum increase in positive or negative height)
	local now = os.clock()
	local height = math.sin(now * speed) * maxHeight
	game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").CameraOffset = Vector3.new(0, height, 0)
end