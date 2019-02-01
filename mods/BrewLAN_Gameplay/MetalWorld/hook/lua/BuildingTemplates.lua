do
    local inserts = {
        {
            'T1MetalWorldResource',
            --UEF       AEON      CYBRAN    SERAPHIM
            {'ueb1103','uab1103','urb1103','xsb1103'},
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
