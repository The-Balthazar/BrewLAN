do
    local inserts = {
        {
            'T4ShieldDefense',
            --UEF       AEON      CYBRAN    SERAPHIM
            {'seb4401','sab4401',  false  ,'ssb4401'},
        },
    }
    for group, data in inserts do
        for i, id in data[2] do
            if BuildingTemplates[i] and id then-- and __blueprints[id] then
                table.insert(BuildingTemplates[i], {data[1], id})
            end
        end
    end
end
