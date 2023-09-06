-- TODO: do a little more reaserch and experimenting, document better the variables and what the function does
-- multiply the now by 3 or speed up time and
-- multiply the result by .1 to make the "orbit" smaller
return function(now, breathHeight, breathSpeed)
	breathHeight = tonumber(breathHeight) or .001
	breathSpeed = tonumber(breathSpeed) or 1
	local humanoid = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
	local orbit1 = Vector3.new(math.sin(now), 0, math.cos(now))
	local orbit2 = Vector3.new(math.sin(now * breathSpeed), 0, math.sin(now * breathSpeed)) * breathHeight
	return (orbit1 + orbit2)
end