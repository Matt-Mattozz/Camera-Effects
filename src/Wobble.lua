-- TODO: do a little more reaserch and experimenting, document better the variables and what the function does

local breathHeight = .1
local breathSpeed = 1
-- multiply the now by 3 or speed up time and
-- multiply the result by .1 to make the "orbit" smaller
return function()
	local now = os.clock()
	local orbit1 = Vector3.new(math.sin(now), 0, math.cos(now))
	local orbit2 = Vector3.new(math.sin(now * breathSpeed), 0, math.sin(now * breathSpeed)) * breathHeight
	workspace.CurrentCamera.CFrame += (orbit1 + orbit2)
end