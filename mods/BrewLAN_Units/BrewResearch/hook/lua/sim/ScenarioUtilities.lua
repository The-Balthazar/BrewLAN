--------------------------------------------------------------------------------
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
do
    local OldCreateInitialArmyGroup = CreateInitialArmyGroup
    function CreateInitialArmyGroup(strArmy, createCommander)
        AddBuildRestriction(strArmy, categories.RESEARCHLOCKED + categories.RESEARCHLOCKEDTECH1 + categories.TECH2 + categories.TECH3 + categories.EXPERIMENTAL)
        if not ScenarioInfo.WindStats then
            ScenarioInfo.WindStats = {Thread = ForkThread(WindThread)}
        end
        return OldCreateInitialArmyGroup(strArmy, createCommander)
    end

    function WindThread()
        WaitTicks(26)
        --Declared locally for performance, since they are used a lot.
        local random = math.random
        local min = math.min
        local max = math.max
        local mod = math.mod
        while true do
            ScenarioInfo.WindStats.Power = min(max( (ScenarioInfo.WindStats.Power or 0.5) + 0.5 - random(),0),1)
            --Defines a real number, starting from 0.5, between 0 and 1 that randomly fluctuates by up to 0.5 either direction.
            --math.random() with no args returns a real number between 0 and 1
            ScenarioInfo.WindStats.Direction = mod((ScenarioInfo.WindStats.Direction or random(0,360)) + random(-5,5) + random(-5,5) + random(-5,5) + random(-5,5), 360)
            --Defines an int between 0 and 360, that fluctuates by up to 20 either direction, with a strong bias towards 0 fluctuation, that cylces around when 0 or 360 is exceeded.
            WaitTicks(30 + 1)
            --Wait ticks waits 1 less tick than it should. #timingissues
        end
    end
end
