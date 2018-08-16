--------------------------------------------------------------------------------
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
do
    local OldCreateInitialArmyGroup = CreateInitialArmyGroup
    function CreateInitialArmyGroup(strArmy, createCommander)
        if createCommander then
            AddBuildRestriction(strArmy, categories.RESEARCHLOCKED + categories.RESEARCHLOCKEDTECH1 + categories.TECH2 + categories.TECH3 + categories.EXPERIMENTAL)
            --GetArmyBrain(strArmy):AISimulateResearch()
        end
        return OldCreateInitialArmyGroup(strArmy, createCommander)
    end

    local OldCreateResources = CreateResources
    function CreateResources()
        if not ScenarioInfo.WindStats then
            ScenarioInfo.WindStats = {Thread = ForkThread(WindThread)}
        end
        OldCreateResources()
    end

    function WindThread()
        WaitTicks(26)
        while true do
            ScenarioInfo.WindStats.Power = math.max(5,math.min(30,(ScenarioInfo.WindStats.Power or 18) + math.random(-15,15)))
            ScenarioInfo.WindStats.Direction = math.mod((ScenarioInfo.WindStats.Direction or math.random(0,360)) + math.random(-5,5) + math.random(-5,5) + math.random(-5,5) + math.random(-5,5), 360)
            WaitTicks(30 + 1)
        end
    end
end
