do
    for i, group in armordefinition do
        if group[1] == 'Commander' then
            table.insert(armordefinition[i], 'CrushingJaw 0.2')
            break
        end
    end
end
