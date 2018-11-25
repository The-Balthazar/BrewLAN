do
    local inserts = {
        {
            'T1ShieldDefense',
            {'seb4102','sab4102','urb4202','ssb4102'},
        },
        {
            'T2EngineerSupport',
            {  false  ,  false  ,  false  ,'ssb0104'},
        },
        {
            'T3Optics',
            {'seb3303',  false  ,  false  ,'ssb3301'},
        },
        {
            'T4Gantry',
            --UEF       AEON      CYBRAN    SERAPHIM
            {'seb0401','sab0401','srb0401','ssb0401'},
        },
        {
            'T4Optics',
            {'seb3404',  false  ,  false  ,  false  },
        },
        {
            'T4ShieldDefense',
            {  false  ,  false  ,'srb4401',  false  },
        },
    }
    for group, data in inserts do
        for i, id in data[2] do
            if BuildingTemplates[i] and id then-- and __blueprints[id] then
                table.insert(BuildingTemplates[i], {data[1], id})
            end
        end
    end
    local swaps = {
        {
            'T2ShieldDefense',
            {'urb4202', 'urb4205'},
        },
        {
            'T3ShieldDefense',
            {'urb4202', 'urb4206'},
        }
    }
    for datai, data in swaps do
        for factioni, groups in BuildingTemplates do
            for i, group in groups do
                if group[1] == data[1] and group[2] == data[2][1] then
                    LOG(BuildingTemplates[factioni][i][2] .. " converting to " .. data[2][2] .. " in group " .. BuildingTemplates[factioni][i][1] )
                    BuildingTemplates[factioni][i][2] = data[2][2]
                end
            end
        end
    end
end
