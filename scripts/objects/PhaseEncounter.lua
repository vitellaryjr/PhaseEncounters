local PhaseEncounter, super = Class(Encounter)

function PhaseEncounter:init()
    super:init(self)

    self.phases = {}
    self.current_phase = 1
    self.current_phase_turn = 1

    self.random_dialogue = {}
    self.random_waves = {}
    self.random_text = {}
end

function PhaseEncounter:onTurnEnd()
    self:incrementPhaseTurn()
end

function PhaseEncounter:getDialogueCutscene()
    local dialogue
    if self.dialogue_override then
        dialogue = self:getDialogueFromData(self.dialogue_override)
        self.dialogue_override = nil
    elseif self.current_phase_turn <= #self.phases[self.current_phase] then
        local dialogue_data = self.phases[self.current_phase][self.current_phase_turn].dialogue
        dialogue = self:getDialogueFromData(dialogue_data)
    else
        local dialogue_data = Utils.pick(self.random_dialogue[self.current_phase] or {})
        dialogue = self:getDialogueFromData(dialogue_data)
    end
    if type(dialogue) == "string" or type(dialogue) == "function" then
        return dialogue
    else
        return "phase_dialogue", dialogue
    end
end

function PhaseEncounter:getNextWaves()
    if self.current_phase_turn <= #self.phases[self.current_phase] then
        local wave_data = self.phases[self.current_phase][self.current_phase_turn].wave
        local wave, enemy = self:getWaveFromData(wave_data)
        enemy.selected_wave = wave
        return {wave}
    else
        local wave_data = Utils.pick(self.random_waves[self.current_phase] or {})
        if not wave_data then
            wave_data = Utils.pick(self.phases[self.current_phase]).wave
        end
        local wave, enemy = self:getWaveFromData(wave_data)
        enemy.selected_wave = wave
        return {wave}
    end
end

function PhaseEncounter:getEncounterText()
    if self.current_phase_turn <= #self.phases[self.current_phase] then
        local text = self.phases[self.current_phase][self.current_phase_turn].text
        if text then
            return text
        end
    else
        local text = Utils.pick(self.random_text[self.current_phase] or {})
        if text then
            return text
        end
    end
    return super:getEncounterText(self)
end

function PhaseEncounter:getDialogueFromData(dialogue_data)
    local enemies = Game.battle:getActiveEnemies()
    if type(dialogue_data) == "function" then
        return dialogue_data
    else
        local dialogue
        if type(dialogue_data) == "string" then
            local bool, new_dialogue = Utils.startsWith(dialogue_data, "cutscene:")
            if bool then
                return new_dialogue
            else
                dialogue = {
                    [enemies[1]] = {dialogue_data}
                }
            end
        elseif type(dialogue_data) == "table" then
            if #dialogue_data > 0 then
                dialogue = {
                    [enemies[1]] = dialogue_data
                }
            else
                dialogue = {}
                for enemy_id, text in pairs(dialogue_data) do
                    if isClass(enemy_id) then
                        dialogue[enemy_id] = text
                    else
                        if string.find(enemy_id, ":") then
                            local enemy_id, index = unpack(Utils.split(enemy_id, ":"))
                            local i = 1
                            for _,enemy in ipairs(enemies) do
                                if enemy.id == enemy_id then
                                    if i == tonumber(index) then
                                        dialogue[enemy] = text
                                        break
                                    end
                                    i = i + 1
                                end
                            end
                        else
                            for _,enemy in ipairs(enemies) do
                                if enemy.id == enemy_id then
                                    dialogue[enemy] = text
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
        for i,text in pairs(dialogue) do
            if type(text) == "string" then
                dialogue[i] = {text}
            end
        end
        return dialogue
    end
end

function PhaseEncounter:getWaveFromData(wave_data)
    if type(wave_data) == "string" then
        return wave_data, Utils.pick(Game.battle:getActiveEnemies())
    else
        if #wave_data > 0 then
            return Utils.pick(wave_data), Utils.pick(Game.battle:getActiveEnemies())
        else
            local wave = wave_data.wave
            if wave and type(wave) == "table" then
                wave = Utils.pick(wave)
            end
            local enemy_id = wave_data.enemy
            if enemy_id then
                if isClass(enemy_id) then
                    return wave, enemy_id
                else
                    if string.find(enemy_id, ":") then
                        local enemy_id, index = unpack(Utils.split(enemy_id, ":"))
                        local i = 1
                        for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
                            if enemy.id == enemy_id then
                                if i == tonumber(index) then
                                    return wave, enemy
                                end
                                i = i + 1
                            end
                        end
                    else
                        for _,enemy in ipairs(Game.battle:getActiveEnemies()) do
                            if enemy.id == enemy_id then
                                return wave, enemy
                            end
                        end
                    end
                end
            else
                return wave, Utils.pick(Game.battle:getActiveEnemies())
            end
        end
    end
end

function PhaseEncounter:addPhase(turns, index)
    index = index or #self.phases + 1
    if type(index) == "number" then
        table.insert(self.phases, index, turns)
    else
        self.phases[index] = turns
    end
end

function PhaseEncounter:addTurnToPhase(turn, phase_index, turn_index)
    index = index or self.current_phase
    self.phases[index] = self.phases[index] or {}
    table.insert(self.phases[index], turn_index or #phase + 1, turn)
end

function PhaseEncounter:randomDialogueForPhase(dialogue, index)
    index = index or #self.phases
    self.random_dialogue[index] = Utils.merge(self.random_dialogue[index] or {}, dialogue)
end

function PhaseEncounter:randomWavesForPhase(waves, index)
    index = index or #self.phases
    self.random_waves[index] = self.random_waves[index] or {}
    if type(waves) == "string" then
        table.insert(self.random_waves[index], waves)
    else
        self.random_waves[index] = Utils.merge(self.random_waves[index], waves)
    end
end

function PhaseEncounter:randomTextForPhase(text, index)
    index = index or #self.phases
    self.random_text[index] = self.random_text[index] or {}
    if type(text) == "string" then
        table.insert(self.random_text[index], text)
    else
        self.random_text[index] = Utils.merge(self.random_text[index], text)
    end
end

function PhaseEncounter:setDialogueOverride(dialogue)
    self.dialogue_override = dialogue
end

function PhaseEncounter:incrementPhase(amt)
    self.current_phase = self.current_phase + (amt or 1)
    self.current_phase_turn = 1
end

function PhaseEncounter:setPhase(index)
    self.current_phase = index
    self.current_phase_turn = 1
end

function PhaseEncounter:incrementPhaseTurn(amt)
    self.current_phase_turn = self.current_phase_turn + (amt or 1)
end

function PhaseEncounter:setPhaseTurn(index)
    self.current_phase_turn = index
end

return PhaseEncounter