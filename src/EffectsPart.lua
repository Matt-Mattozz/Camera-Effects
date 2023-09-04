local EffectsPart = {}
EffectsPart.__index = EffectsPart

function EffectsPart.new()
    local self = {
        Part = Instance.new("Part"),
        Offset = Vector3.new(0, 0, 0), -- TODO: this offset doesn't point to where the camera would point if CameraSubject 
                                    -- was the humanoid. It seems to be about Vector3.new(0, 2, 0), probably depends
                                    -- on the height of the character and the distance between HumanoidRootPart and
                                    -- the head of the character
        Enabled = false,
        previousCameraSubject = nil,
        currentCameraSubject = nil,
        enableConnection = nil,
    }
    self["Part"].Transparency = 1
    self["Part"].Size = Vector3.new(0.001, 0.001, 0.001)
    self["Part"].Anchored = true
    self["Part"].CanCollide = false
    self["Part"].CanTouch = false

    setmetatable(self, EffectsPart)
    return self
end

function EffectsPart:Enable(cameraSubject : BasePart?)
    if self["Enabled"] then return end
    self["Enabled"] = true
    if not cameraSubject then
        if workspace.CurrentCamera.CameraSubject:IsA("Humanoid") then
            cameraSubject = workspace.CurrentCamera.CameraSubject.Parent:FindFirstChild("HumanoidRootPart")
        end
    end
    assert(cameraSubject:IsA("BasePart"), "cameraSubject must be of type BasePart")

    self["Part"].Parent = workspace
    self["previousCameraSubject"] = workspace.CurrentCamera.CameraSubject
    self["currentCameraSubject"] = cameraSubject
    workspace.CurrentCamera.CameraSubject = self["Part"]

    self["enableConnection"] = game:GetService("RunService").RenderStepped:Connect(function()
        self["Part"].CFrame = self["currentCameraSubject"].CFrame + self["Offset"]
    end)
end

function EffectsPart:Disable()
    if not self["Enabled"] then return end
    self["enableConnection"]:Disconnect()
    self["Part"].Parent = game.ReplicatedStorage
    self["currentCameraSubject"] = nil
    workspace.CurrentCamera.CameraSubject = self["previousCameraSubject"]
    self["previousCameraSubject"] = nil
    self["Enabled"] = false
end

return EffectsPart