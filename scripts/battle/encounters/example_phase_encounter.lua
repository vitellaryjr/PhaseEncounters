local Example, super = Class(PhaseEncounter)

function Example:init()
    super:init(self)

    local dummy1 = self:addEnemy("dummy")
    local dummy2 = self:addEnemy("dummy")

    self:addPhase({
        {
            dialogue = {
                ["dummy"] = "hii!",
            },
            wave = "basic",
        },
        {
            dialogue = {
                ["dummy:1"] = {"hi!!", "hi!!"},
                ["dummy:2"] = {nil, "hi!!"},
            },
            wave = {
                wave = "basic",
                enemy = "dummy:1",
            },
        }
    })
    self:randomDialogueForPhase(1, {
        {
            ["dummy:1"] = {"hi!!"},
        },
        {
            ["dummy:2"] = {"hi!!"},
        },
    })

    self:addPhase({
        {
            dialogue = {
                [dummy1] = "you fucked up",
                [dummy2] = "you fucked up",
            },
            wave = "basic2",
        }
    })
    self:randomWavesForPhase(2, {
        "basic",
        "basic2",
    })
end

return Example