--------------------------------------------------------------------------------
-- Hook File: /lua/game.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do
    local OldGetConstructEconomyModel = GetConstructEconomyModel
    
    function GetConstructEconomyModel(builder, targetData, ...)
        if
          builder:GetBlueprint().BlueprintId == targetData.HalfPriceUpgradeFromID
        or
          builder:GetBlueprint().General.UpgradesTo == targetData.HalfPriceUpgradeFromID
        or
          builder:GetBlueprint().Economy.BuilderDiscountMult
        then
            local builder_bp = builder:GetBlueprint()
            local rate = builder:GetBuildRate()
            local buildtime = targetData.BuildTime or 0.1
            local discount = targetData.UpgradeFromCostDiscount or builder:GetBlueprint().Economy.BuilderDiscountMult or 0.5
            local mass = math.max((targetData.BuildCostMass or 0) * discount, 0)
            local energy = math.max((targetData.BuildCostEnergy or 0) * discount, 0)
            
            buildtime = math.max(buildtime * (100 + (builder.BuildTimeModifier or 0))*.01, 0.1)
            energy = math.max(energy * (100 + (builder.EnergyModifier or 0))*.01, 0)
            mass = math.max(mass * (100 + (builder.MassModifier or 0))*.01, 0)
            
            return buildtime/rate, energy, mass
        --elseif builder:GetBlueprint().Economy.BuilderDiscount then
        else
            return OldGetConstructEconomyModel(builder, targetData, unpack(arg))
        end
    end
    
    --------------------------------------------------------------------------------
    -- Adapted from Manimal's mod locator script.
    -- Because I'm sick of people moaning when they put it in the wrong hole.
    -- Note to self: UID also in blueprints.lua and mod_info.lua
    --------------------------------------------------------------------------------
    BrewLANPath = function()
        for i, mod in __active_mods do
            if mod.uid == "25D57D85-7D84-27HT-A501-BR3WL4N000079" then
                return mod.location
            end
        end 
    end   
end
