--------------------------------------------------------------------------------
--  Summary  :  Cybran Combat Engineer Script
--------------------------------------------------------------------------------
local CConstructionUnit = import('/lua/cybranunits.lua').CConstructionUnit
local CDFElectronBolterWeapon = import('/lua/cybranweapons.lua').CDFElectronBolterWeapon
--------------------------------------------------------------------------------
SRL0119 = Class(CConstructionUnit) {
    Weapons = {
        Bolter = Class(CDFElectronBolterWeapon) {},
    },

    OnCreate = function(self)
        CConstructionUnit.OnCreate(self)
        if self:GetAIBrain().BrainType == 'Human' then
            self:AddBuildRestriction(categories.urb4206)
        end
    end,

    OnStopBeingBuilt = function(self, ...)
        self:SetMaintenanceConsumptionActive()
        CConstructionUnit.OnStopBeingBuilt(self, unpack(arg) )
    end,

    OnStartBuild = function(self, unitBeingBuilt, order)
        --Disable the gun while building something
        self:SetWeaponEnabledByLabel('Bolter', false)
        CConstructionUnit.OnStartBuild(self, unitBeingBuilt, order)
    end,

    OnStopBuild = function(self)
        --Re-enable the gun after done building
        self:SetWeaponEnabledByLabel('Bolter', true)
        CConstructionUnit.OnStopBuild(self)
    end,

    OnStartReclaim = function(self, target)
        CConstructionUnit.OnStartReclaim(self, target)
        self:SetAllWeaponsEnabled(false)
    end,

    OnStopReclaim = function(self, target)
        CConstructionUnit.OnStopReclaim(self, target)
        self:SetAllWeaponsEnabled( true)
    end,
}

TypeClass = SRL0119
