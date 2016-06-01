do           
    local Units = {
        PARAGON = {
            "peb1401",
            "prb1401",
            "psb1401",
        },
        ENGISTATION = {
            "pab0104",
        },
    }  
    for k, v in Units do
        --Checks the table exists, for the sake of FAF restrictions
        if restrictedUnits[k] then
            for i in v do  
                --Checks the unit exists, just in case
                if categories[v[i]] then
                    table.insert(restrictedUnits[k].categories, v[i])
                end
            end
        end
    end
    table.removeByValue(restrictedUnits.GAMEENDERS.categories, "xab1401")  
end
