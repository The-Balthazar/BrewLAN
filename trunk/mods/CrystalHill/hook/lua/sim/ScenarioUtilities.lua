-- ScenarioUtilities.lua (hooked)--
-- Author      : Daniel Teh
-- Description :
--
-- Copyright © 2007 Gas Powered Games - All rights reserved

#--[  CreateInitialArmyGroup                                                     ]--
#--[                                                                             ]--
function CreateInitialArmyGroup(strArmy, createCommander)
    local tblGroup = CreateArmyGroup( strArmy, 'INITIAL')
    local cdrUnit = false

    if createCommander and ( tblGroup == nil or 0 == table.getn(tblGroup) ) then
        local factionIndex = GetArmyBrain(strArmy):GetFactionIndex()
        local initialUnitName = import('/lua/factions.lua').Factions[factionIndex].InitialUnit
        cdrUnit = CreateInitialArmyUnit(strArmy, initialUnitName)
        if EntityCategoryContains(categories.COMMAND, cdrUnit) then
            if ScenarioInfo.Options['PrebuiltUnits'] == 'Off' then
                cdrUnit:HideBone(0, true)
                ForkThread(CommanderWarpDelay, cdrUnit, 1)
            end
        end
        if not ScenarioInfo.Crystal then
            GetArmyBrain(strArmy):SpawnCrystal()
        end
    end

    return tblGroup, cdrUnit
end