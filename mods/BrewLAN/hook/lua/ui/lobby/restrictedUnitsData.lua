do
    local Units = {
        GAMEENDERS = {
            "srb2401",
            "ssb2404",
        },
        BUBBLES = {
            --Tech 1 shields
            "sab4102",
            "seb4102",
            "ssb4102",
            --Cybran shields
            "urb4204",
            "urb4205",
            "urb4206",
            "urb4207",
            "srb4401",
        },
    }  
    for k, v in Units do
        for i in v do  
            table.insert(restrictedUnits[k].categories, v[i])
        end
    end
end