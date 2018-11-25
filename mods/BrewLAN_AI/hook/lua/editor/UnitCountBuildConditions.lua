function GantryCapCheck(aiBrain, locationType, factoryType)
    local catCheck = false
    if factoryType == 'Gantry' then
        catCheck = categories.GANTRY * categories.FACTORY * categories.STRUCTURE
    else
        WARN('*AI WARNING: Invalid factorytype - ' .. factoryType)
        return false
    end
    local factoryManager = aiBrain.BuilderManagers[locationType].FactoryManager
    if not factoryManager then
        WARN('*AI WARNING: FactoryCapCheck - Invalid location - ' .. locationType)
        return false
    end
    local numUnits = factoryManager:GetNumCategoryFactories(catCheck) + aiBrain:GetEngineerManagerUnitsBeingBuilt(catCheck)
    if numUnits < aiBrain.BuilderManagers[locationType].BaseSettings.FactoryCount[factoryType] then
        return true
    end
    return false
end

--[[function EngineerCapCheck(aiBrain, locationType, techLevel)
    local catCheck = false
    if techLevel == 'Tech1' then
        catCheck = categories.TECH1
    elseif techLevel == 'Tech2' then
        catCheck = categories.TECH2
    elseif techLevel == 'Tech3' then
        catCheck = categories.TECH3
    elseif techLevel == 'SCU' then
        catCheck = categories.SUBCOMMANDER
    else
        WARN('*AI WARNING: Invalid techLevel - ' .. techLevel)
        return false
    end
    local engineerManager = aiBrain.BuilderManagers[locationType].EngineerManager
    if not engineerManager then
        WARN('*AI WARNING: EngineerCapCheck - Invalid location - ' .. locationType)
        return false
    end
    local numUnits = engineerManager:GetNumCategoryUnits('Engineers', catCheck)
    if numUnits < aiBrain.BuilderManagers[locationType].BaseSettings.EngineerCount[techLevel] then
        return true
    end
    return false
end
]]
