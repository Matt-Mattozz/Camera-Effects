--[=[
    @class CameraEffects
    Apply and remove custom and pre-made effects for the Camera
]=]
local CameraEffects = {}
local SustainedCreator = require(script.SustainedCreator)
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
CameraEffects.SustainedList = {
    -- added each entry "the manual way" to make them show with autocomplete
    ["Wobble"] = SustainedCreator.new(require(script:FindFirstChild("Sustained"):FindFirstChild("Wobble"))),
    ["Bounce"] = SustainedCreator.new(require(script:FindFirstChild("Sustained"):FindFirstChild("Bounce")))
}
--[[(function()
    local sustained = {}
    for _, effectModule in ipairs(script:FindFirstChild("Sustained"):GetChildren()) do
        sustained[effectModule.Name] = SustainedCreator.new(require(effectModule))
    end
    return sustained
end)()]]
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
    Saves the current camera values
]=]
local function saveCameraValues()
    CameraEffects.valsBefore["FieldOfView"] = CameraEffects.playerCamera["FieldOfView"]
    --CameraEffects.valsBefore["CFrame"] = 
      --  CameraEffects.valsBefore["CameraSubject"].Parent:FindFirstChild("HumanoidRootPart").CFrame:Inverse():
        --ToWorldSpace(CameraEffects.playerCamera.CFrame)
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
    CameraEffects.valsBefore = {}
end
--[=[
    @within CameraEffects
    @private
    @ignore
    Binds the function of an effect to the RenderStepped event of RunService
]=]
local function bindSustainedEffect(sustainedCreatorInstance : SustainedCreator)
    return game:GetService("RunService").RenderStepped:Connect(function()
        sustainedCreatorInstance["Function"](table.unpack(sustainedCreatorInstance["Parameters"]))
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
function CameraEffects.EnableSustained(sustainedCreatorInstance : SustainedCreator, ...: any)
    saveCameraValues()
    CameraEffects.conns[sustainedCreatorInstance] = bindSustainedEffect(sustainedCreatorInstance)
end
--[=[
    Disables the given camera effect of the Sustained folder
]=]
function CameraEffects.DisableSustained(sustainedCreatorInstance : SustainedCreator)
    CameraEffects.conns[sustainedCreatorInstance]:Disconnect()
    CameraEffects.conns[sustainedCreatorInstance] = nil
    if #CameraEffects.conns == 0 then
        local t = game:GetService("TweenService"):Create(
            game.Players.LocalPlayer.Character.Humanoid, TweenInfo.new(0.5), {CameraOffset = Vector3.new(0, 0, 0)})
        t:Play()
        t.Completed:Wait()
        applyOriginalValuesToCamera() -- TODO, it might interfere with Once effects
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