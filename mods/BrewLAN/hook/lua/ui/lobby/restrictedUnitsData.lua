do
    table.insert(restrictedUnits.GAMEENDERS.categories, "srb2401")
    local shields = {
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
    }
    for i, v in shields do
        table.insert(restrictedUnits.BUBBLES.categories, v)
    end
end