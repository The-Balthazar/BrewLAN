do
    OldPlatoon = Platoon
    Platoon = Class(OldPlatoon) {

        ExperimentalAIHub = function(self)
            local defaultbehavior = OldPlatoon.ExperimentalAIHub
            if not defaultbehavior then return end
            return self:ExperimentalHubBrewLAN() or defaultbehavior(self)
        end,

        ExperimentalAIHubSorian = function(self)
            local defaultbehavior = OldPlatoon.ExperimentalAIHubSorian
            if not defaultbehavior then return end
            return self:ExperimentalHubBrewLAN() or defaultbehavior(self)
        end,

        ExperimentalHubBrewLAN = function(self)
            local behaviors = import('/lua/ai/AIBehaviors.lua')
            local id = self:GetPlatoonUnits()[1]:GetUnitId()
            if id == 'sal0401' then
                if behaviors.FatBoyBehaviorSorian then
                    return behaviors.FatBoyBehaviorSorian(self) --pretend to be a fatboy for now
                elseif behaviors.FatBoyBehavior then
                    return behaviors.FatBoyBehavior(self) --pretend to be a fatboy for now
                end
            elseif id == 'sea0401' then
                return behaviors.CenturionBehaviorBrewLAN(self) --centurion behaviour
            end
            return
        end,
    }
end
