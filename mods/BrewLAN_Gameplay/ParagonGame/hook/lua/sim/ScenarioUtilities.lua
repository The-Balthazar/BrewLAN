--------------------------------------------------------------------------------
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
do
    local OldCreateInitialArmyGroup = CreateInitialArmyGroup
    function CreateInitialArmyGroup(strArmy, createCommander)
        GetArmyBrain(strArmy):ParagonOrNotCheck(strArmy)
        return OldCreateInitialArmyGroup(strArmy, createCommander)
    end
end
