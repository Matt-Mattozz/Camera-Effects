--!strict
--[=[
    @class CameraEffects
    @client
    Apply and remove custom and pre-made effects for the Camera
]=]
local CameraEffects = {}
local SustainedCreator = require(script.SustainedCreator)
type SustainedEffect = SustainedCreator.SustainedEffect
local valsBefore = {}
local playerCamera = workspace:WaitForChild("Camera")
local db = false
--[=[
    @within CameraEffects
    @prop SustainedList {[string] : SustainedCreator}
    @private
    @readonly
    List of all the Sustained effects
]=]
CameraEffects.SustainedList = {
    -- added each entry "the manual way" to make them show with autocomplete
    ["Wobble"] = SustainedCreator.new("Wobble", require(script:FindFirstChild("Sustained"):FindFirstChild("Wobble"))),
    ["Bounce"] = SustainedCreator.new("Bounce", require(script:FindFirstChild("Sustained"):FindFirstChild("Bounce")))
}
--[=[
    @within CameraEffects
    @prop OnceList {[number] : any}
    @private
    @readonly
    List of all the Once effects
]=]
CameraEffects.OnceList = {}
--[=[
    @within CameraEffects
    @private
    @ignore
    Saves the current camera values
]=]
local function saveCameraValues()
    valsBefore["FieldOfView"] = playerCamera["FieldOfView"]
    --valsBefore["CFrame"] = 
      --  valsBefore["CameraSubject"].Parent:FindFirstChild("HumanoidRootPart").CFrame:Inverse():
        --ToWorldSpace(playerCamera.CFrame)
end
--[=[
    @within CameraEffects
    @private
    @ignore
    Applies to the current camera the values of the current camera before any effect was enabled
]=]
local function applyOriginalValuesToCamera(t: number?)
    t = t or 1
    local tween = game:GetService("TweenService"):Create(
        playerCamera, TweenInfo.new(t), {FieldOfView = valsBefore["FieldOfView"]}
    )
    tween:Play()
    valsBefore = {}
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
function CameraEffects.EnableSustained(sustainedEffect : SustainedEffect, ...: any)
    if db then repeat task.wait() until not db end
    db = true
    sustainedEffect:Enable()
    saveCameraValues()
    db = false
end
--[=[
    Disables the given camera effect of the Sustained folder
]=]
function CameraEffects.DisableSustained(sustainedEffect : SustainedEffect)
    sustainedEffect:Disable()
    for _, effect in pairs(CameraEffects.SustainedList) do
        if effect["_totalTime"] > 0 then -- there's not the possibility that one effect may be paused because CameraEffects class doesn't offer this possibility
            return
        end
    end
    local t = game:GetService("TweenService"):Create(
        game.Players.LocalPlayer.Character.Humanoid, TweenInfo.new(0.5), {CameraOffset = Vector3.new(0, 0, 0)})
    t:Play()
    t.Completed:Wait()
    applyOriginalValuesToCamera() -- TODO, it might interfere with Once effects
end
--[=[
    Disables all camera effects currently enabled of the Sustained folder
]=]
function CameraEffects.DisableAllSustained()
    for _, effect in pairs(CameraEffects.SustainedList) do
        CameraEffects.DisableSustained(effect)
    end
end

return CameraEffects