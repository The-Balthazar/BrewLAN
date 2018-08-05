--------------------------------------------------------------------------------
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
do
    local OldCreateInitialArmyGroup = CreateInitialArmyGroup
    function CreateInitialArmyGroup(strArmy, createCommander)
        if createCommander then
            GetArmyBrain(strArmy):LuckyDip(strArmy)
        end
        return OldCreateInitialArmyGroup(strArmy, createCommander)
    end
end
