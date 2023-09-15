local CameraEffects = require(script.Parent.Parent.Parent:WaitForChild("CameraEffects"))

return function()
    describe("CameraEffects.SustainedList", function()
    
        it("checks that all elements are SustainedCreator instances", function()
            for _, effect in ipairs(CameraEffects.SustainedList) do
                expect(effect["Name"]).to.be.ok()
                expect(effect["Function"]).to.be.ok()
                expect(effect["Parameters"]).to.be.ok()
                expect(effect["_totalTime"]).to.be.ok()
            end
        end)

    end)

    describe("CameraEffects.EnableSustained", function()
        
        it("enables the Wobble effect", function()
            CameraEffects.EnableSustained(CameraEffects.SustainedList.Wobble)
            local initTime = os.clock()
            task.wait(.2)
            expect(CameraEffects.SustainedList.Wobble["_totalTime"]).to.be.near(os.clock()-initTime, .05)
            CameraEffects.DisableSustained(CameraEffects.SustainedList.Wobble)
        end)

        it("enables the Wobble effect only once and ignores the other invocations", function()
            CameraEffects.EnableSustained(CameraEffects.SustainedList.Wobble)
            local initTime = os.clock()
            for i = 1, 5 do -- enables it multiple times to make sure the invocations after the first are ignored
                CameraEffects.EnableSustained(CameraEffects.SustainedList.Wobble)
            end
            task.wait(.2)
            expect(CameraEffects.SustainedList.Wobble["_totalTime"]).to.be.near(os.clock()-initTime, .05)
            CameraEffects.DisableAllSustained()
        end)

    end)

    describe("CameraEffects.DisableSustained", function()

        it("disables the Wobble effect", function()
            CameraEffects.EnableSustained(CameraEffects.SustainedList.Wobble)
            task.wait(.5)
            for i = 1, 3 do -- tries multiple times to make sure it doesn't break even if called multiple times
                CameraEffects.DisableSustained(CameraEffects.SustainedList.Wobble)
            end
            task.wait(.05) -- makes sure the effect was reset
            expect(CameraEffects.SustainedList.Wobble["_totalTime"]).to.be.equal(0)
        end)

    end)

    describe("CameraEffects.DisableAllSustained", function()
    
        it("disables all effects contained in SustainedList", function()
            for _, effect in pairs(CameraEffects.SustainedList) do
                CameraEffects.EnableSustained(effect)
            end
            task.wait(.5)
            CameraEffects.DisableAllSustained()
            task.wait(.1) -- makes sure the effects were reset
            for _, effect in pairs(CameraEffects.SustainedList) do
                expect(effect["_totalTime"]).to.be.equal(0)
            end
        end)

    end)

end