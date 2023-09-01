--[=[
    @class CameraEffects
    Apply and remove custom and pre-made effects for the Camera
]=]
local CameraEffects = {}
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
    @prop effectsList
    @private
    @readonly
    Local player's camera
]=]
CameraEffects.effectsList = (function()
    local effectsArray = {}
    for _, effectModule in ipairs(script:GetChildren()) do
        effectsArray[effectModule.Name] = require(CameraEffects.effectsList)
    end
    return effectsArray
end)()
--[=[
    @within CameraEffects
    @private
    @ignore
    Saves the current camera values
]=]
local function saveCameraValues()
    for _, valueName in ipairs({"CFrame", "CameraSubject", "CameraType", "DiagonalFieldOfView", "FieldOfView", 
    "FieldOfViewMode", "MaxAxisFieldOfView"}) do
        CameraEffects.valuesBeforeEffect[valueName] = CameraEffects.playerCamera[valueName]
    end
end
--[=[
    @within CameraEffects
    @private
    @ignore
    Applies the values contained in CameraEffects.valuesBeforeEffect to CameraEffects.playerCamera 
]=]
local function applyOriginalValuesToCamera()
    for name, value in ipairs(CameraEffects.valuesBeforeEffect) do
        CameraEffects.playerCamera[name] = value
    end
end
--[=[
    @within CameraEffects
    @private
    @ignore
    Binds the function of an effect to the RenderStepped event of RunService
]=]
local function bindCameraEffect(effectFunction : () -> ())
    return game:GetService("RunService").RenderStepped:Connect(function()
        effectFunction()
    end)
end
--[=[
    Enables a certain camera effect given it's name
]=]
function CameraEffects.EnableEffect(effectName : string)
    saveCameraValues()
    CameraEffects.effectsConnection[effectName] = bindCameraEffect(CameraEffects.effectsList[effectName])
end
--[=[
    Disables a camera effect given it's name
]=]
function CameraEffects.DisableEffect(effectName : string)
    if not CameraEffects.effectsConnection[effectName] then return end
    CameraEffects.effectsConnection[effectName]:Disconnect()
    table.remove(CameraEffects.effectsConnection[effectName])
end
--[=[
    Disables all camera effects currently enabled
]=]
function CameraEffects.DisableAllEffects()
    for _, effectConnection in ipairs(CameraEffects.effectsConnections) do
        CameraEffects.DisableEffect(effectConnection)
    end
    applyOriginalValuesToCamera()
end

return CameraEffects