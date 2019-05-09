local OldAIExecuteBuildStructure = AIExecuteBuildStructure

function AIExecuteBuildStructure(aiBrain, builder, buildingType, ...)
    local OldFunction = OldAIExecuteBuildStructure(aiBrain, builder, buildingType, unpack(arg))
    if not OldFunction and not aiBrain.BrewRND.ResearchIsComplete then
        local targetID = ConvertBuildingType(aiBrain, buildingType)
        if targetID then
            for i, id in targetID do
                --WARN("SENDING AI RESEARCH REQUEST: " .. id)
                aiBrain.BrewRND.AddResearchRequest(aiBrain, id)
            end
        end
    end
    return OldFunction
end

local BuildingTemplates = import('/lua/buildingtemplates.lua').BuildingTemplates

function ConvertBuildingType(aiBrain, buildingType)
    local check = {}
    for i, v in BuildingTemplates[aiBrain:GetFactionIndex()] do
        if v[1] == buildingType and not table.find(check, v[2]) then
            table.insert(check, v[2])
        end
    end
    if check[1] then
        return check
    else
        return
    end
end
