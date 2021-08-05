do
    local inserts = {
        {
            'T1ResearchCentre',
            --UEF       CYBRAN    AEON      SERAPHIM
            {'seb9101','sab9101','srb9101','ssb9101'},
        },
        {
            'T1EnergyProduction',
            {'seb1101','sab1101','srb1101','ssb1101'},
        },
        {
            'T1EnergyProduction',
            {'seb1102','sab1102',not'srb1102','ssb1102'},
        },
        {
            'T2EnergyProduction',
            {'seb1201','sab1201','srb1201','ssb1201'},
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
