--[=[
    @class CameraEffects
    Apply and remove custom and pre-made effects for the Camera
]=]
local CameraEffects = {}
local EffectsPart = require(script.EffectsPart)
--[=[
    @within CameraEffects
    @prop valsBefore
    @private
    @readonly
    @ignore
    Contains the values of some property of the camera before any effect was applied to it
]=]
CameraEffects.valsBefore = {}
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
    @prop conns
    @private
    @readonly
    @ignore
    Contains the connection of all the effects (when enabled)
]=]
CameraEffects.conns = {}
--[=[
    @within CameraEffects
    @prop SustainedList
    @private
    @readonly
    List of all the sustained effects
]=]
CameraEffects.SustainedList = (function()
    local sustained = {}
    for _, effectModule in ipairs(script:FindFirstChild("Sustained"):GetChildren()) do
        sustained[effectModule.Name] = require(effectModule)
    end
    return sustained
end)()
--[=[
    @within CameraEffects
    @prop OnceList
    @private
    @readonly
    List of all the Once effects
]=]
CameraEffects.OnceList = (function()
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
        CameraEffects.valsBefore[valueName] = CameraEffects.playerCamera[valueName]
    end
    CameraEffects.valsBefore["CFrame"] = 
        CameraEffects.valsBefore["CameraSubject"].Parent:FindFirstChild("HumanoidRootPart").CFrame:Inverse():
        ToWorldSpace(CameraEffects.playerCamera.CFrame)
end
--[=[
    @within CameraEffects
    @private
    @ignore
    Applies the values contained in CameraEffects.valsBefore to CameraEffects.playerCamera 
]=]
local function applyOriginalValuesToCamera(t: number?)
    t = t or 1
    local tween = game:GetService("TweenService"):Create(
        CameraEffects.playerCamera, TweenInfo.new(t), {FieldOfView = CameraEffects.valsBefore["FieldOfView"]}
    )
    tween:Play()
    tween.Completed:Wait()
    for name, value in pairs(CameraEffects.valsBefore) do
        if name ~= "FieldOfView" and name ~= "CFrame" then
            CameraEffects.playerCamera[name] = value
        end
    end
    CameraEffects.valsBefore = {}
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
    if not CameraEffects.OnceList[effectName] then warn("Effect "..effectName.." doesn't exist!")
        return
    end
    CameraEffects.OnceList[effectName](...)
end
--[=[
    Enables an effect from the Sustained folder
]=]
function CameraEffects.EnableSustained(effectName : string, ...: any)
    if not CameraEffects.SustainedList[effectName] then warn("Effect "..effectName.." doesn't exist!") 
        return 
    end
    saveCameraValues()
    if #CameraEffects.conns == 0 then
        CameraEffects.effectsPart:Enable()
    end
    CameraEffects.conns[effectName] = bindSustainedEffect(CameraEffects.SustainedList[effectName](
        CameraEffects.effectsPart, ...))
end
--[=[
    Disables the given camera effect of the Sustained folder
]=]
function CameraEffects.DisableSustained(effectName : string)
    if not CameraEffects.conns[effectName] then warn("Effect "..effectName.." doesn't exist!")
        return
    end
    CameraEffects.conns[effectName]:Disconnect()
    CameraEffects.conns[effectName] = nil
    if #CameraEffects.conns == 0 then
        applyOriginalValuesToCamera() -- TODO, it might interfere with Once effects
        CameraEffects.effectsPart:Disable()
    end
end
--[=[
    Disables all camera effects currently enabled of the Sustained folder
]=]
function CameraEffects.DisableAllSustained()
    for effectName, _ in pairs(CameraEffects.conns) do
        CameraEffects.DisableSustained(effectName)
    end
end

return CameraEffects