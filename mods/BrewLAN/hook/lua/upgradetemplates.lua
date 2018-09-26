do
    local StructureUpgradeTemplatesIncludes = {
        --UEF
        {
            --Shield
            { 'seb4102', 'ueb4202'},
        },

        --Aeon
        {
            --shields
            { 'sab4102', 'uab4202'},
            { 'uab4202', 'uab4301'},
        },

        --Cybran
        {
        },

        --Seraphim
        {
    		--Engineering Station
    		{ 'ssb0104', 'ssb0204'},
    		{ 'ssb0204', 'ssb0304'},

            --Shield
            { 'ssb4102', 'xsb4202'},
        },
    }
    for i = 1, 4 do
        for k, group in StructureUpgradeTemplatesIncludes[i] do
            table.insert(StructureUpgradeTemplates[i], group)
        end
    end
end
