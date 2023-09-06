--[=[
    @class SustainedCreator
    @client
    Creates Sustained effects and makes them modifiable at runtime
]=]
local SustainedCreator = {}
SustainedCreator.__index = SustainedCreator
local player = game.Players.LocalPlayer
local character = player.Character
local humanoid = character:WaitForChild("Humanoid")
--[=[
    @interface SustainedEffectProperties
    .Name string
    .Function (...any) -> ()
    .Parameters {any}
    ._totalTime number
    @within SustainedCreator
    Properties of the SustainedEffect instance
]=]
type SustainedEffectProperties = {
    Name : string,
    Function : (...any) -> (Vector3),
    Parameters : {any},
    _totalTime : number
}
--[=[
    @type SustainedEffect typeof(setmetatable({} :: SustainedEffectProperties, SustainedCreator))
    @within SustainedCreator
    Sustained effect instance
]=]
export type SustainedEffect = typeof(setmetatable({} :: SustainedEffectProperties, SustainedCreator))
--[=[
    Constructor for the class
]=]
function SustainedCreator.new(name : string, func : (...any) -> (Vector3), ...: any)
    local self = {
        Name = name,
        Function = func,
        Parameters = {...},
        _totalTime = 0,
        -- Connection
    } :: SustainedEffectProperties
    return setmetatable(self, SustainedCreator) :: SustainedEffect
end
--[=[
    @within SustainedCreator
    @private
    @ignore
    Gets the first position returned by the effect that will become the Humanoid.CameraOffset
]=]
local function GetFirstPosition(effect : SustainedEffect) : Vector3
    return effect["Function"](effect["_totalTime"], table.unpack(effect["Parameters"]))
end
--[=[
    @within SustainedCreator
    @private
    @ignore
    Places the camera at the first position returned by the effect
]=]
local function PlaceAtFirstPosition(effect : SustainedEffect)
    local firstPosition = GetFirstPosition(effect)
    if (firstPosition - humanoid.CameraOffset).Magnitude > 0.25 then
        local tween = game:GetService("TweenService"):Create(humanoid, TweenInfo.new(.1), {CameraOffset = firstPosition})
        tween:Play()
        tween.Completed:Wait()
    end
end
--[=[
    Enables the effect
]=]
function SustainedCreator:Enable()
    PlaceAtFirstPosition(self)
    game:GetService("RunService"):BindToRenderStep(
        self["Name"], 
        Enum.RenderPriority.Camera.Value, 
        function(t : number)
            humanoid.CameraOffset = self["Function"](self["_totalTime"], table.unpack(self["Parameters"])) 
            self["_totalTime"] += t
        end
    )
end
--[=[
    Pauses the effect. Once restarted the Humanoid.CameraOffset will be the same of when the effect was paused and
    it will progress from there
]=]
function SustainedCreator:Pause()
    game:GetService("RunService"):UnbindFromRenderStep(self["Name"])
end
--[=[
    Disables the effect and resets the progression of the effect. Once restarted the Humanoid.CameraOffset will be 
    reset to the first (in order) CFrame returned by the effect
]=]
function SustainedCreator:Disable()
    self:Pause()
    self["_totalTime"] = 0
end
--[=[
    Updates a parameter
    -- Issue: If you modify a parameter whose [parameterIndex > 1] and the array has holes (example: {[1] = "a", [3] = "c"}),
    --  for some reason the parameters after the hole will not be read inside the function
]=]
function SustainedCreator:UpdateParameter(parameterIndex : number, value : any)
    self:Pause()
    self["Parameters"][parameterIndex] = value
    self:Enable()
end


return SustainedCreator