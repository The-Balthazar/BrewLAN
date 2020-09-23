do
    local Units = {
        GAMEENDERS = {"srl0403"},
    }
    for group, data in pairs(restrictedUnits) do
        if data.categories then
            if Units[group] then
                for i, id in Units[group] do
                    table.insert(restrictedUnits[group].categories, id)
                end
            end
            for i, cat in data.categories do
                if __blueprints[cat .."rnd"] then
                    table.insert(restrictedUnits[group].categories, cat.."rnd")
                end
            end
        end
    end
end
