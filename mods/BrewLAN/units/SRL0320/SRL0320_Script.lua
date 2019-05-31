local CLandUnit = import('/lua/cybranunits.lua').CLandUnit
local CAAMissileNaniteWeapon = import('/lua/cybranweapons.lua').CAAMissileNaniteWeapon
local EffectUtil = import('/lua/EffectUtilities.lua')

SRL0320 = Class(CLandUnit) {

    IntelEffects = {
        {
            Bones = {0},
            Offset = {0, 1, 0},
            Type = 'Jammer01',
        },
    },

    Weapons = {
        MainGun = Class(CAAMissileNaniteWeapon) {
            CreateProjectileAtMuzzle = function(self, muzzle)
                if self.unit.IntelOn then
                    self.unit.IntelOn = nil
                    self.unit:SetMaintenanceConsumptionInactive()
                    self.unit:SetScriptBit('RULEUTC_CloakToggle', true)
                    self.unit:DisableUnitIntel('Cloak')
                    self.unit:RequestRefreshUI()
                    self.unit.IntelWasOn = true
                end
                CAAMissileNaniteWeapon.CreateProjectileAtMuzzle(self, muzzle)
            end,
            OnWeaponFired = function(self)
                if self.unit.IntelWasOn then
                    self.unit.IntelOn = true
                    self.unit:SetMaintenanceConsumptionActive()
                    self.unit:SetScriptBit('RULEUTC_CloakToggle', false)
                    self.unit:EnableUnitIntel('Cloak')
                    self.unit:RequestRefreshUI()
                    self.unit.IntelWasOn = nil
                end
                CAAMissileNaniteWeapon.OnWeaponFired(self)
            end,
        },
    },

    OnStopBeingBuilt = function(self,builder,layer)
        CLandUnit.OnStopBeingBuilt(self,builder,layer)
        if self:GetAIBrain().BrainType == 'Human' then
            self:SetMaintenanceConsumptionInactive()
            self:SetScriptBit('RULEUTC_CloakToggle', true)
            self:RequestRefreshUI()
        else
            self:SetMaintenanceConsumptionActive()
            self:SetScriptBit('RULEUTC_CloakToggle', false)
            self:EnableUnitIntel('Cloak')
            self:RequestRefreshUI()
        end
    end,

    OnIntelEnabled = function(self)
        CLandUnit.OnIntelEnabled(self)
        if self.IntelEffects and not self.IntelFxOn and self.IntelOn then
            self:PlaySound(self:GetBlueprint().Audio.Cloak)
            self.IntelEffectsBag = {}
            self.CreateTerrainTypeEffects( self, self.IntelEffects, 'FXIdle',  self:GetCurrentLayer(), nil, self.IntelEffectsBag )
            self.IntelFxOn = true
        end
    end,

    OnIntelDisabled = function(self)
        CLandUnit.OnIntelDisabled(self)
        if self.IntelFxOn == true then
            self:PlaySound(self:GetBlueprint().Audio.Decloak)
            EffectUtil.CleanupEffectBag(self,'IntelEffectsBag')
            self.IntelFxOn = nil
        end
    end,

    OnScriptBitSet = function(self, bit)
        if bit == 8 then -- cloak toggle
            self.IntelOn = nil
        end
        CLandUnit.OnScriptBitSet(self, bit)
    end,

    OnScriptBitClear = function(self, bit)
        if bit == 8 then -- cloak toggle
            self.IntelOn = true
        end
        CLandUnit.OnScriptBitClear(self, bit)
    end,
}

TypeClass = SRL0320
