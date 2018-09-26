do
    for i = 1, 4 do
        if BaseTemplates[i] then
            if not table.find(BaseTemplates[i][1][1],'T4ShieldDefense') then
                table.insert(BaseTemplates[i][1][1],'T4ShieldDefense')
            end
        end
    end
end
