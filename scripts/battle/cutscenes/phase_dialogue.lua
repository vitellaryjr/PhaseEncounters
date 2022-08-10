return function(cutscene, dialogue)
    local max = 1
    for _,v in pairs(dialogue) do
        if #v > max then
            max = #v
        end
    end
    for i=1,max do
        local texts = {}
        local last_text
        for k,v in pairs(dialogue) do
            local text = v[i]
            if text and text ~= "" then
                texts[k] = text
                last_text = k
            end
        end
        for k,v in pairs(texts) do
            cutscene:battlerText(k, v, {wait = last_text == k})
        end
    end
end