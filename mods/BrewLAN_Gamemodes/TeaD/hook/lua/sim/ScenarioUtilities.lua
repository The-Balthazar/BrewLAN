--------------------------------------------------------------------------------
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
do
    local OldCreateInitialArmyGroup = CreateInitialArmyGroup
    function CreateInitialArmyGroup(strArmy, createCommander)
        local tblGroup = CreateArmyGroup( strArmy, 'INITIAL')
        if createCommander and ( tblGroup == nil or 0 == table.getn(tblGroup) ) then
            local aiteam, teamgame = GetArmyBrain(strArmy):AIOnlyTeam(strArmy)  
            if aiteam then
                if not teamgame then
                    --Warning?
                end
                GetArmyBrain(strArmy):SpawnCreepGates()
                --return CreateInitialArmyUnit(strArmy, 'tec0000')
            else
                GetArmyBrain(strArmy):SpawnLifeCrystal()
                return OldCreateInitialArmyGroup(strArmy, createCommander)
            end
        end
        
    end
end