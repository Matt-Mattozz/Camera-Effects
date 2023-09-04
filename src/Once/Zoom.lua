-- zooms on a subject and keeps the zoom on it
-- TODO
--[[
return function(toLookAt : Vector3 | BasePart, FOV : number?, time : number?, easingStyle : Enum.EasingStyle?, easingDirection : Enum.EasingDirection?)
    FOV = FOV or 30
    time = time or 1
    easingStyle = easingStyle or Enum.EasingStyle.Sine
    easingDirection = easingDirection or Enum.EasingDirection.InOut
    local posToLookAt
    if typeof(toLookAt) == "Vector3" then
        posToLookAt = toLookAt
    elseif typeof(toLookAt) == "BasePart" then
        posToLookAt = toLookAt.Position
    end
    return function()
        local t = game:GetService("TweenService"):Create(
            workspace.CurrentCamera,
            TweenInfo.new(time, easingStyle, easingDirection),
            {CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, posToLookAt), FieldOfView = FOV}
        )
        t:Play()
        t.Completed:Wait()
        if typeof(toLookAt) == "BasePart" then
           workspace.CurrentCamera.CameraSubject = toLookAt
        end
    end
end]]