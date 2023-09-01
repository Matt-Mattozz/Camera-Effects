-- makes the camera go up and down continously
local speed = 1 -- the speed with which the camera goes up and down (higher = faster)
local maxHeight = .3 -- how much the camera goes up and down (maximum increase in height, both positive and negative)

return function()
	local now = os.clock()
	local height = math.sin(now * speed) * maxHeight

	workspace.CurrentCamera.CFrame += Vector3.new(0, height, 0)
end