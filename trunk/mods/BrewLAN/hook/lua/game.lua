--------------------------------------------------------------------------------
-- Hook File: /lua/game.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do
    local OldGetConstructEconomyModel = GetConstructEconomyModel
    
    function GetConstructEconomyModel(builder, targetData, upgradeBaseData)
        if builder:GetBlueprint().BlueprintId == targetData.HalfPriceUpgradeFromID then
            local builder_bp = builder:GetBlueprint()
            local rate = builder:GetBuildRate()
            local buildtime = targetData.BuildTime or 0.1
            local mass = math.max((targetData.BuildCostMass or 0) * 0.5, 0)
            local energy = math.max((targetData.BuildCostEnergy or 0) * 0.5, 0)
            
            buildtime = math.max(buildtime * (100 + (builder.BuildTimeModifier or 0))*.01, 0.1)
            energy = math.max(energy * (100 + (builder.EnergyModifier or 0))*.01, 0)
            mass = math.max(mass * (100 + (builder.MassModifier or 0))*.01, 0)
            
            return buildtime/rate, energy, mass
        elseif upgradeBaseData then
            --FAF compatibility
            return OldGetConstructEconomyModel(builder, targetData, upgradeBaseData)
        else
            return OldGetConstructEconomyModel(builder, targetData)
        end
    end
end