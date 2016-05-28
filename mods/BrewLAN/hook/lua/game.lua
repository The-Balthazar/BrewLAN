--------------------------------------------------------------------------------
-- Hook File: /lua/game.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do
    local OldGetConstructEconomyModel = GetConstructEconomyModel
    
    function GetConstructEconomyModel(builder, targetData, ...)
        if builder:GetBlueprint().BlueprintId == targetData.HalfPriceUpgradeFromID or builder:GetBlueprint().General.UpgradesTo == targetData.HalfPriceUpgradeFromID then
            local builder_bp = builder:GetBlueprint()
            local rate = builder:GetBuildRate()
            local buildtime = targetData.BuildTime or 0.1
            local discount = targetData.UpgradeFromCostDiscount or 0.5
            local mass = math.max((targetData.BuildCostMass or 0) * discount, 0)
            local energy = math.max((targetData.BuildCostEnergy or 0) * discount, 0)
            
            buildtime = math.max(buildtime * (100 + (builder.BuildTimeModifier or 0))*.01, 0.1)
            energy = math.max(energy * (100 + (builder.EnergyModifier or 0))*.01, 0)
            mass = math.max(mass * (100 + (builder.MassModifier or 0))*.01, 0)
            
            return buildtime/rate, energy, mass
        else
            return OldGetConstructEconomyModel(builder, targetData, unpack(arg))
        end
    end
    
    --------------------------------------------------------------------------------
    -- Adapted from Manimal's mod locator script.
    -- Because I'm sick of people moaning when they put it in the wrong hole.
    -- Note to self: Remember to update the UID when I change it for next version.
    --------------------------------------------------------------------------------
    BrewLANPath = function()
        for i, mod in __active_mods do
            if mod.uid == "25D57D85-7D84-27HT-A501-BR3WL4N000075" then
                return mod.location
            end
        end 
    end   
    --[[local BrewLAN_UID = "25D57D85-7D84-27HT-A501-BR3WL4N000075" 
      
    local GetMyActiveMod = function( byName, byUID, byAuthor )
        for i, leMod in __active_mods do
            if (byName   and ( byName   == leMod.name   )) 
            or (byUID    and ( byUID    == leMod.uid    ))
            or (byAuthor and ( byAuthor == leMod.author )) then
            return leMod
            end
        end
        WARN("MANIMAL\'s MOD FINDER:  Unable to get Mod Infos ! Either your mod is not installed or you have mistyped its name, UID or author.")
        return {}
    end
    
    local GetMyActiveModLocation = function( leMod )
        if leMod and (type(leMod) == 'table') then
            return leMod.location
        end
        WARN("MANIMAL\'s MOD LOCATOR:  Unable to get Mod Infos ! Either your mod is not installed or you have mistyped its name, UID or author.")
        return ''
    end

    BrewLANMod = GetMyActiveMod( false, BrewLAN_UID, false )
    BrewLANPath = GetMyActiveModLocation( MonMod )
     ]]--

end