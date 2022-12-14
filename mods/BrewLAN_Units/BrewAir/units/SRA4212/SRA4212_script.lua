local CAirUnit = import('/lua/cybranunits.lua').CAirUnit
local Maser = import('/lua/cybranweapons.lua').CDFParticleCannonWeapon--CDFHeavyMicrowaveLaserGeneratorCom
local CleanupEffectBag = import('/lua/EffectUtilities.lua').CleanupEffectBag

local function SetCloakState(self, state)
    if state then
        self:EnableUnitIntel'Cloak'
        self:SetMaintenanceConsumptionActive()
        if self.IntelEffects and not self.IntelFxOn then
            self:PlaySound(self:GetBlueprint().Audio.Cloak)
            self.IntelFxOn = true
            self.IntelEffectsBag = {}
            self.CreateTerrainTypeEffects( self, self.IntelEffects, 'FXIdle',  self:GetCurrentLayer(), nil, self.IntelEffectsBag )
        end
    else
        self:DisableUnitIntel'Cloak'
        self:SetMaintenanceConsumptionInactive()
        if self.IntelFxOn then
            self:PlaySound(self:GetBlueprint().Audio.Decloak)
            self.IntelFxOn = nil
            CleanupEffectBag(self, 'IntelEffectsBag')
        end
    end
    self:RequestRefreshUI()
end

SRA4212 = Class(CAirUnit) {

    Weapons = {
        MainLaser = Class(Maser) {
            CreateProjectileAtMuzzle = function(self, muzzle)
                SetCloakState(self.unit, false)
                Maser.CreateProjectileAtMuzzle(self, muzzle)
            end,
        },
    },

    IntelEffects = {
        {
            Bones = {0},
            Offset = {0, 0, 0},
            Type = 'Jammer01',
        },
    },

    OnStopBeingBuilt = function(self,builder,layer)
        CAirUnit.OnStopBeingBuilt(self,builder,layer)
        local isHuman = self:GetAIBrain().BrainType == 'Human'

        self:SetScriptBit('RULEUTC_CloakToggle', isHuman) -- start off for humans
        SetCloakState(self, not isHuman)
    end,

    OnLayerChange = function(self, new, old)
        CAirUnit.OnLayerChange(self, new, old)
        self.Landed = new == 'Land'
        if self.Landed and self.IntelOn then
            SetCloakState(self, self.IntelOn)
        end
    end,

    -- Enable
    OnScriptBitClear = function(self, bit)
        if bit == 8 then -- cloak toggle
            self.IntelOn = true
            if self.Landed then
                SetCloakState(self, true)
            end
        else
            CAirUnit.OnScriptBitClear(self, bit)
        end
    end,

    -- Disable
    OnScriptBitSet = function(self, bit)
        if bit == 8 then -- cloak toggle
            self.IntelOn = nil
            SetCloakState(self, false)
        end
        CAirUnit.OnScriptBitSet(self, bit)
    end,

    OnRunOutOfFuel = function(self)
        CAirUnit.OnRunOutOfFuel(self)
        local noFuelMult = self:GetBlueprint().Physics.NoFuelSpeedMult or 0.6
        self:SetSpeedMult(noFuelMult)
        self:SetAccMult(noFuelMult)
        self:SetTurnMult(noFuelMult)
        SetCloakState(self, false)
    end,
}

TypeClass = SRA4212
