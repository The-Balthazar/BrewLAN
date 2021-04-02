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
        end
    end
end
