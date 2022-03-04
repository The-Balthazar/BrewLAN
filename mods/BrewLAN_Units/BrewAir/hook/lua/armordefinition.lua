do
    for i, group in armordefinition do
        if group[1] ~= 'Light' and group[1] ~= 'ASF' then
            table.insert(armordefinition[i], group[1]:find'Structure' and 'LightMissile 0.25' or 'LightMissile 0.5')
        end
    end
end
