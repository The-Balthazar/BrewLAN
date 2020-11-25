do
    local Units = {
        INTEL = {
            --Original omni sensors, no longer covered by 'OMNI' cat
            'uab3104',
            'ueb3104',
            'urb3104',
            'xsb3104',
            --Omni sensors
            'sab3301',
            'seb3301',
            'srb3301',
            --'ssb3302',
        },
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
