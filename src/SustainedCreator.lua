--[=[
    @class SustainedCreator
    Creates Sustained effects and makes them modifiable at runtime
]=]
local SustainedCreator = {}
--[=[
    Constructor for the class
]=]
function SustainedCreator.new(func : (...any) -> (), ...: any)
    local self = {
        Function = func,
        Parameters = {...}
    }
    return self
end
return SustainedCreator