local SStructureUnit = import('/lua/seraphimunits.lua').SStructureUnit
local SSJammerCrystalAmbient = import('/lua/EffectTemplates.lua').SJammerCrystalAmbient
local EffectUtil = import('/lua/EffectUtilities.lua')

SSB4317 = Class(SStructureUnit) {
--------------------------------------------------------------------------------
-- Basic calls
--------------------------------------------------------------------------------
    OnStopBeingBuilt = function(self,builder,layer)
        SStructureUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetMaintenanceConsumptionActive()
        self.Holograms = {}
        local pos = self:GetPosition()
        self:ForkThread(self.LandBlipThread, pos)
        self:ForkThread(self.AirBlipThread, pos)
    end,

    OnIntelEnabled = function(self)
        SStructureUnit.OnIntelEnabled(self)
        self.IntelEffectsBag = {}
        for k, v in SSJammerCrystalAmbient do
            table.insert(self.IntelEffectsBag, CreateAttachedEmitter(self, 'Cylinder001', self:GetArmy(), v))
        end
        self.Intel = true
    end,

    OnIntelDisabled = function(self)
        SStructureUnit.OnIntelDisabled(self)
        EffectUtil.CleanupEffectBag(self,'IntelEffectsBag')
        self:DestroyChildren(true)
        self.Intel = false
    end,

    OnKilled = function(self, instigator, type, excessDamageRatio)
        self:DestroyChildren()
        SStructureUnit.OnKilled(self, instigator, type, excessDamageRatio)
    end,

    OnDestroy = function(self)
        self:DestroyChildren()
        SStructureUnit.OnKilled(self)
    end,

--------------------------------------------------------------------------------
-- Controlling loops
--------------------------------------------------------------------------------
    LandBlipThread = function(self, pos)
        while not self:IsDead() do
            --Spawn land blips
            if self.Intel then
                self:SpawnHologram(pos, 'SSL0001', 1)
            end
            WaitSeconds(Random(7,13))
            self:DestroyChildren(1)
            --WaitSeconds(Random(2,7))
        end
    end,

    AirBlipThread = function(self, pos)
        while not self:IsDead() do
            --Spawn air blips
            if self.Intel then
                self:SpawnHologram(pos, 'SSA0002', 2)
            end
            WaitSeconds(Random(7,13))
            self:DestroyChildren(2)
            --WaitSeconds(Random(2,7))
        end
    end,

--------------------------------------------------------------------------------
-- Main functions
--------------------------------------------------------------------------------
    SpawnHologram = function(self, pos, unitid, ref)
        self.Holograms[ref] = CreateUnitHPR(unitid, self:GetArmy(), pos[1] + Random(-10, 10), pos[2], pos[3] + Random(-10, 10), 0, 0, 0)
        --self.Holograms[ref].parentCrystal = self
        for i = 1, Random(3,5) do
            IssuePatrol({self.Holograms[ref]}, {pos[1] + Random(-10, 10), pos[2], pos[3] + Random(-10, 10)})
        end
    end,

    DestroyChildren = function(self, var)
        if type(var) ~= "boolean" then
            if self.Holograms[var] then
                self.Holograms[var]:Destroy()
                self.Holograms[var] = nil
            end
        else --if nothing specif, then we are dying. Cleanup.
            for i, v in self.Holograms do
                if v then
                    self.Holograms[i]:Destroy()
                    if var then
                        self.Holograms[i] = nil
                    end
                end
            end
        end
    end,

}

TypeClass = SSB4317
