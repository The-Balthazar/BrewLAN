--------------------------------------------------------------------------------
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
do
    local OldCreateInitialArmyGroup = CreateInitialArmyGroup
    function CreateInitialArmyGroup(strArmy, createCommander)
        if createCommander then
            GetArmyBrain(strArmy):ParagonOrNotCheck(strArmy)
        end
        return OldCreateInitialArmyGroup(strArmy, createCommander)
    end
end
