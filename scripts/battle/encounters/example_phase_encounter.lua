local Example, super = Class(PhaseEncounter)

function Example:init()
    super:init(self)

    local dummy1 = self:addEnemy("dummy")
    local dummy2 = self:addEnemy("dummy")

    -- defines the first phase of the battle
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
            text = "* The dummies are happy to see you!",
        }
    })
    -- random dialogue to be played after all turns in phase 1 have occurred
    self:randomDialogueForPhase({
        {
            ["dummy:1"] = {"hi!!"},
        },
        {
            ["dummy:2"] = {"hi!!"},
        },
    })

    -- defines the second phase of the battle
    self:addPhase({
        {
            dialogue = {
                [dummy1] = "you fucked up",
                [dummy2] = "you fucked up",
            },
            wave = "basic2",
            text = "* The dummies are PISSED",
        }
    })
    -- random waves to be used after all turns in phase 2 have occurred
    self:randomWavesForPhase({
        "basic",
        "basic2",
    })
    self:randomTextForPhase({
        "* The dummies are PISSED",
        "* you fucked up big time",
    })
end

return Example