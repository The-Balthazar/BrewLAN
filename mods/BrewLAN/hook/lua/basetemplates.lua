do
    local groups = {
        {
            --UEF
            'T1ShieldDefense',
            'T4Gantry',
            'T4Optics',
        },
        {
            --Aeon
            'T1ShieldDefense',
            'T4Gantry',
        },
        {
            --Cybran
            'T1ShieldDefense',
            'T4Gantry',
            'T4ShieldDefense',
        },
        {
            --Seraphim
            'T1ShieldDefense',
            'T4Gantry',
        },
    }
    for i = 1, 4 do
        if BaseTemplates[i] then
            for platoonindex, platoon in groups[i] do
                table.insert(BaseTemplates[i][1][1], platoon)
            end
        end
    end
end
