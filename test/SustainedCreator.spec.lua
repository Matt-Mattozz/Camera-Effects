local SustainedCreator = require(script.Parent.Parent:WaitForChild("src"):WaitForChild("SustainedCreator"))

return function()

    describe("SustainedCreator.new", function()

        it("should create a Sustained effect", function()
            local effect = SustainedCreator.new("test", function(a) return Vector3.new() end)
            expect(effect["Name"]).to.be.ok()
            expect(effect["Function"]).to.be.ok()
            expect(effect["Parameters"]).to.be.ok()
            expect(effect["_totalTime"]).to.be.ok()
        end)

        it("should throw an invalid name type error", function()
            expect(SustainedCreator.new(0)).to.throw("expected type string, got number instead.")
        end)

        it("should throw an invalid function type error", function()
            expect(SustainedCreator.new("test", 0)).to.throw("expected type function, got number instead.")
        end)

        it("should throw an invalid function return type error", function()
            expect(SustainedCreator.new("test", function() return 0 end)).to.throw("function should return a value of type Vector3, but returned number instead.")
        end)

    end)

    describe("SustainedCreator:Enable", function()

        it("should enable the custom effect", function()
            local effect = SustainedCreator.new("test", function(a) return Vector3.new() end)
            effect:Enable()
            task.wait(.2)
            effect:Pause()
            expect(effect["_totalTime"]).to.be.near(.2, .2)
        end)

        it("should enable the custom effect only once and ignore the other invocations", function()
            local effect = SustainedCreator.new("test", function(a) return Vector3.new() end)
            for i = 1, 6 do
                effect:Enable()
            end
            task.wait(.2)
            effect:Pause()
            expect(effect["_totalTime"]).to.be.near(.2, .1)
        end)

    end)

    describe("SustainedCreator:Pause", function()
    
        it("should pause the custom effect", function()
            local effect = SustainedCreator.new("test", function(a) return Vector3.new() end)
            effect:Enable()
            task.wait(.2)
            effect:Pause()
            expect(effect["_totalTime"]).to.be.near(.2, .1)
        end)

        it("should ignore the method call (because the effect is not enabled)", function()
            local effect = SustainedCreator.new("test", function(a) return Vector3.new() end)
            effect:Pause()
        end)

    end)

    describe("SustainedCreator:Disable", function()
    
        it("should disable the custom effect", function()
            local effect = SustainedCreator.new("test", function(a) return Vector3.new() end)
            effect:Enable()
            task.wait(.2)
            effect:Disable()
            task.wait()
            expect(effect["_totalTime"]).to.be.equal(0)
        end)

        it("should ignore the method call (because the effect is not enabled)", function()
            local effect = SustainedCreator.new("test", function(a) return Vector3.new() end)
            effect:Disable()
        end)

    end)

    describe("SustainedCreator:UpdateParameter", function()

        it("should update the parameters passed to the function", function()
            local effect = SustainedCreator.new("test", function(a) return Vector3.new() end)
            effect:UpdateParameter(1, 0)
            effect:UpdateParameter(2, "a")
            expect(effect["Parameters"][1]).to.be.equal(0)
            expect(effect["Parameters"][2]).to.be.equal("a")
        end)

        -- Issue: If you modify a parameter whose [parameterIndex > 1] and the array has holes (example: {[1] = "a", [3] = "c"}),
        --  for some reason the parameters after the hole will not be read inside the function
        itSKIP("should update only the second parameter passed to the function", function()
            local effect = SustainedCreator.new("test", function(a) return Vector3.new() end)
            effect:UpdateParameter(2, 0)
            expect(effect["Parameters"][1]).to.be.equal(nil)
            expect(effect["Parameters"][2]).to.be.equal(0)
        end)

    end)

end