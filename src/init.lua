--[=[
    @class CameraEffects
    Apply and remove custom and pre-made effects for the Camera
]=]
local CameraEffects = {}
local EffectsPart = require(script.EffectsPart)
--[=[
    @within CameraEffects
    @prop valuesBeforeEffect
    @private
    @readonly
    @ignore
    Contains the values of some property of the camera before any effect was applied to it
]=]
CameraEffects.valuesBeforeEffect = {}
--[=[
    @within CameraEffects
    @prop playerCamera
    @private
    @readonly
    @ignore
    Local player's camera
]=]
CameraEffects.playerCamera = workspace:WaitForChild("Camera")
--[=[
    @within CameraEffects
    @prop effectsConnections
    @private
    @readonly
    @ignore
    Contains the connection of all the effects (when enabled)
]=]
CameraEffects.effectsConnections = {}
--[=[
    @within CameraEffects
    @prop SustainedEffectsList
    @private
    @readonly
    List of all the sustained effects
]=]
CameraEffects.SustainedEffectsList = (function()
    local sustained = {}
    for _, effectModule in ipairs(script:FindFirstChild("Sustained"):GetChildren()) do
        sustained[effectModule.Name] = require(effectModule)
    end
    return sustained
end)()
--[=[
    @within CameraEffects
    @prop OnceEffectsList
    @private
    @readonly
    List of all the Once effects
]=]
CameraEffects.OnceEffectsList = (function()
    local once = {}
    for _, effectModule in ipairs(script:FindFirstChild("Once"):GetChildren()) do
        once[effectModule.Name] = require(effectModule)
    end
    return once
end)()
--[=[
    @within CameraEffects
    @private
    @ignore
    The part that once a Sustained effect is started, will act as CameraSubject and make the application of an offset possible 
]=]
CameraEffects.effectsPart = EffectsPart.new()
--[=[
    @within CameraEffects
    @private
    @ignore
    Saves the current camera values
]=]
local function saveCameraValues()
    for _, valueName in ipairs({"CameraSubject", "CameraType", "DiagonalFieldOfView", "FieldOfView", 
    "FieldOfViewMode", "MaxAxisFieldOfView"}) do
        CameraEffects.valuesBeforeEffect[valueName] = CameraEffects.playerCamera[valueName]
    end
    CameraEffects.valuesBeforeEffect["CFrame"] = 
        CameraEffects.valuesBeforeEffect["CameraSubject"].Parent:FindFirstChild("HumanoidRootPart").CFrame:Inverse():
        ToWorldSpace(CameraEffects.playerCamera.CFrame)
end
--[=[
    @within CameraEffects
    @private
    @ignore
    Applies the values contained in CameraEffects.valuesBeforeEffect to CameraEffects.playerCamera 
]=]
local function applyOriginalValuesToCamera(t: number?)
    t = t or 1
    local tween1 = game:GetService("TweenService"):Create(
        game.Players.LocalPlayer.Character:FindFirstChild("Humanoid"),
        TweenInfo.new(t), 
        {CameraOffset = Vector3.new(0, 0, 0)}
    )
    local tween2 = game:GetService("TweenService"):Create(
        CameraEffects.playerCamera, 
        TweenInfo.new(t), 
        {FieldOfView = CameraEffects.valuesBeforeEffect["FieldOfView"]}
    )
    tween1:Play()
    tween2:Play()
    tween2.Completed:Wait()
    for name, value in pairs(CameraEffects.valuesBeforeEffect) do
        if name ~= "FieldOfView" and name ~= "CFrame" then
            CameraEffects.playerCamera[name] = value
        end
    end
    CameraEffects.valuesBeforeEffect = {}
end
--[=[
    @within CameraEffects
    @private
    @ignore
    Binds the function of an effect to the RenderStepped event of RunService
]=]
local function bindSustainedEffect(effectFunction : () -> ())
    return game:GetService("RunService").RenderStepped:Connect(function()
        effectFunction()
    end)
end
--[=[
    Applies an effect from the Once folder
]=]
function CameraEffects.ApplyEffectOnce(effectName : string, ...: any)
    if not CameraEffects.OnceEffectsList[effectName] then warn("Effect "..effectName.." doesn't exist!")
        return
    end
    CameraEffects.OnceEffectsList[effectName](...)
end
--[=[
    Enables an effect from the Sustained folder
]=]
function CameraEffects.EnableSustained(effectName : string, ...: any)
    if not CameraEffects.SustainedEffectsList[effectName] then warn("Effect "..effectName.." doesn't exist!") 
        return 
    end
    saveCameraValues()
    if #CameraEffects.effectsConnections == 0 then
        CameraEffects.effectsPart:Enable()
    end
    CameraEffects.effectsConnections[effectName] = bindSustainedEffect(CameraEffects.SustainedEffectsList[effectName](
        CameraEffects.effectsPart, ...))
end
--[=[
    Disables the given camera effect of the Sustained folder
]=]
function CameraEffects.DisableSustained(effectName : string)
    if not CameraEffects.effectsConnections[effectName] then warn("Effect "..effectName.." doesn't exist!")
        return
    end
    CameraEffects.effectsConnections[effectName]:Disconnect()
    CameraEffects.effectsConnections[effectName] = nil
    if #CameraEffects.effectsConnections == 0 then
        applyOriginalValuesToCamera() -- TODO, it might interfere with Once effects
        CameraEffects.effectsPart:Disable()
    end
end
--[=[
    Disables all camera effects currently enabled of the Sustained folder
]=]
function CameraEffects.DisableAllSustained()
    for effectName, _ in pairs(CameraEffects.effectsConnections) do
        CameraEffects.DisableSustained(effectName)
    end
end

return CameraEffects