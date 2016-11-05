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
                if Random(1,5) == 3 and (not aiBrain.LastTaunt or GetGameTimeSeconds() - aiBrain.LastTaunt > 90) then
                    local randelay = Random(60,180)
                    aiBrain.LastTaunt = GetGameTimeSeconds() + randelay
                    SUtils.AIDelayChat('enemies', ArmyBrains[aiBrain:GetArmyIndex()].Nickname, 't4taunt', nil, randelay)
                end
                local ID = experimental:GetUnitId()
                
                self:SetPlatoonFormationOverride('AttackFormation')
                
                if ID == 'sal0401' then              
                    --LOG("Absolution pretending to be a Fatboy innitiated")
                    return behaviors.FatBoyBehaviorSorian(self)
                elseif ID == 'sea0401' then                  
                    --LOG("Centurion behaviour script innitiated")
                    return behaviors.CenturionBehaviorBrewLAN(self)
                elseif ID == 'seb0401' then
                    LOG("GANTRY BEHAVIOUR COULD GO HERE")
                    sorianoldPlatoon.ExperimentalAIHubSorian(self)
                end
                
                sorianoldPlatoon.ExperimentalAIHubSorian(self)
            end,
        } 
    end
end
