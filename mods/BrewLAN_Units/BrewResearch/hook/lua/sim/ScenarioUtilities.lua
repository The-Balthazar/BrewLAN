--------------------------------------------------------------------------------
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
do
    local OldCreateInitialArmyGroup = CreateInitialArmyGroup
    function CreateInitialArmyGroup(strArmy, createCommander)
        if createCommander then
            AddBuildRestriction(strArmy,categories.RESEARCHLOCKED)
        end
        return OldCreateInitialArmyGroup(strArmy, createCommander)
    end
end
