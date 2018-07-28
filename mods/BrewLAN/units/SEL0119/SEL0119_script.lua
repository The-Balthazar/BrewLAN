--------------------------------------------------------------------------------
--  Summary  :  UEF Combat Engineer T1
--------------------------------------------------------------------------------
local EffectTemplate = import('/lua/EffectTemplates.lua')
local TConstructionUnit = import('/lua/terranunits.lua').TConstructionUnit
local TDFRiotWeapon = import('/lua/terranweapons.lua').TDFRiotWeapon

SEL0319 = Class(TConstructionUnit) {
    Weapons = {
        Riotgun01 = Class(TDFRiotWeapon) {
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank,
            FxMuzzleFlashScale = 0.75,
        },
    },

    OnStopBeingBuilt = function(self, ...)
        self:SetMaintenanceConsumptionActive()
        TConstructionUnit.OnStopBeingBuilt(self, unpack(arg))
        --Rotate the antenna
        self.Rotator = CreateRotator(self, 'Antenna', 'y')
        self.Trash:Add(self.Rotator)
        self.Rotator:SetSpinDown(false)
        self.Rotator:SetTargetSpeed(30)
        self.Rotator:SetAccel(20)
    end,

    OnStartBuild = function(self, unitBeingBuilt, order)
        if not ScenarioInfo.ArmySetup[self:GetAIBrain().Name].RC then
            --Disable the gun while building something
            self:SetWeaponEnabledByLabel('Riotgun01', false)
        end
        TConstructionUnit.OnStartBuild(self, unitBeingBuilt, order)
    end,

    OnStopBuild = function(self)
        if not ScenarioInfo.ArmySetup[self:GetAIBrain().Name].RC then
            --Re-enable the gun after done building
            self:SetWeaponEnabledByLabel('Riotgun01', true)
        end
        TConstructionUnit.OnStopBuild(self)
    end,

    OnStartReclaim = function(self, target)
        TConstructionUnit.OnStartReclaim(self, target)
        if not ScenarioInfo.ArmySetup[self:GetAIBrain().Name].RC then
            self:SetAllWeaponsEnabled(false)
        end
    end,

    OnStopReclaim = function(self, target)
        TConstructionUnit.OnStopReclaim(self, target)
        if not ScenarioInfo.ArmySetup[self:GetAIBrain().Name].RC then
            self:SetAllWeaponsEnabled( true)
        end
    end,
}

TypeClass = SEL0319
