--------------------------------------------------------------------------------
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
do
    local OldCreateInitialArmyGroup = CreateInitialArmyGroup
    function CreateInitialArmyGroup(strArmy, createCommander)
        local tblGroup = CreateArmyGroup( strArmy, 'INITIAL')
        if createCommander and ( tblGroup == nil or 0 == table.getn(tblGroup) ) then
            GetArmyBrain(strArmy):ParagonOrNotCheck(strArmy)
        end
        return OldCreateInitialArmyGroup(strArmy, createCommander)
    end
end
