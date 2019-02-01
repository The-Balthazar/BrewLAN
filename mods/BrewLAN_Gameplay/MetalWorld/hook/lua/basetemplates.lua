do
    for i = 1, 4 do
        if BaseTemplates and BaseTemplates[i] then
            if not table.find(BaseTemplates[i][1][1],'T1MetalWorldResource') then
                table.insert(BaseTemplates[i][1][1],'T1MetalWorldResource')
            end
        end
    end
end
