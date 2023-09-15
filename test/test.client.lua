for i = 1,5 do -- makes sure it was not a coincidence
    local testEz = require(script.Parent:WaitForChild("TestEZ")).TestBootstrap:run(script:WaitForChild("TestCases"):GetChildren())
end