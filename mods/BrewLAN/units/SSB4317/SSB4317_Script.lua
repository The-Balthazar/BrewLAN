local SStructureUnit = import('/lua/seraphimunits.lua').SStructureUnit
local SSJammerCrystalAmbient = import('/lua/EffectTemplates.lua').SJammerCrystalAmbient
local EffectUtil = import('/lua/EffectUtilities.lua')

SSB4317 = Class(SStructureUnit) {

    OnStopBeingBuilt = function(self,builder,layer)
        SStructureUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetMaintenanceConsumptionActive()
        --self:ForkThread(self.LandBlipThread)
        --self:ForkThread(self.AirBlipThread)
    end,

    OnIntelEnabled = function(self)
        SStructureUnit.OnIntelEnabled(self)
        self.IntelEffectsBag = {}
        for k, v in SSJammerCrystalAmbient do
            table.insert(self.IntelEffectsBag, CreateAttachedEmitter(self, 'Cylinder001', self:GetArmy(), v))
        end
    end,

    OnIntelDisabled = function(self)
        SStructureUnit.OnIntelDisabled(self)
        EffectUtil.CleanupEffectBag(self,'IntelEffectsBag')
    end,

    --[[LandBlipThread = function(self)
        local position = self:GetPosition()

        while not self:IsDead() do
            --Spawn land blips
            self.landChildUnit = CreateUnitHPR('XSC9010', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
            self.landChildUnit.parentCrystal = self

            WaitSeconds(Random(7,13))

            self.landChildUnit:Destroy()
            self.landChildUnit = nil

            #WaitSeconds(Random(2,7))
        end
    end,

    AirBlipThread = function(self)
        local position = self:GetPosition()

        while not self:IsDead() do
            --Spawn air blips
            self.airChildUnit = CreateUnitHPR('XSC9011', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
            self.airChildUnit.parentCrystal = self

            IssuePatrol({self.airChildUnit}, {position[1] + Random(-10, 10), position[2], position[3] + Random(-10, 10)})
            IssuePatrol({self.airChildUnit}, {position[1] + Random(-10, 10), position[2], position[3] + Random(-10, 10)})
            IssuePatrol({self.airChildUnit}, {position[1] + Random(-10, 10), position[2], position[3] + Random(-10, 10)})
            IssuePatrol({self.airChildUnit}, {position[1] + Random(-10, 10), position[2], position[3] + Random(-10, 10)})

            WaitSeconds(Random(7,13))

            self.airChildUnit:Destroy()
            self.airChildUnit = nil

            #WaitSeconds(Random(2,7))
        end
    end,]]--

    OnKilled = function(self, instigator, type, excessDamageRatio)
        --if self.airChildUnit then self.airChildUnit:Destroy() end
        --if self.landChildUnit then self.landChildUnit:Destroy() end
        SStructureUnit.OnKilled(self, instigator, type, excessDamageRatio)
    end,
}

TypeClass = SSB4317
