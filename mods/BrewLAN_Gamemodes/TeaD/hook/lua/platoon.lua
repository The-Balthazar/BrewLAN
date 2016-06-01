do  
    if Platoon.ExperimentalAIHubSorian then
        local SUtils = import('/lua/AI/sorianutilities.lua')
        
        sorianoldPlatoon = Platoon
        
        Platoon = Class(sorianoldPlatoon) {
        
            ExperimentalAIHubSorian = function(self)
                
                local aiBrain = self:GetBrain()
                local behaviors = import('/lua/ai/AIBehaviors.lua')
                
                local experimental = self:GetPlatoonUnits()[1]
                if not experimental then
                    return
                end
                if false and Random(1,5) == 3 and (not aiBrain.LastTaunt or GetGameTimeSeconds() - aiBrain.LastTaunt > 90) then
                    local randelay = Random(60,180)
                    aiBrain.LastTaunt = GetGameTimeSeconds() + randelay
                    SUtils.AIDelayChat('enemies', ArmyBrains[aiBrain:GetArmyIndex()].Nickname, 't4taunt', nil, randelay)
                end
                local ID = experimental:GetUnitId()
                
                self:SetPlatoonFormationOverride('AttackFormation')
                
                for i = 1, 9 do
                    if ID == 'tec000' .. i then  
                        return behaviors.BehaviorCreepTeaD(self)
                    end
                end
                sorianoldPlatoon.ExperimentalAIHubSorian(self)
            end,
        } 
    end
end
