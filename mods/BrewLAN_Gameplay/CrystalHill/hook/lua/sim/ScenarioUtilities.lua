--------------------------------------------------------------------------------
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
do
    local OldCreateInitialArmyGroup = CreateInitialArmyGroup
    function CreateInitialArmyGroup(strArmy, createCommander)
        if not ScenarioInfo.Crystal then
            ScenarioInfo.Crystal = {}   
            GetArmyBrain(strArmy):SpawnCrystal()
        end
        return OldCreateInitialArmyGroup(strArmy, createCommander)
    end
end
