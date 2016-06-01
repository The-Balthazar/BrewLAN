#****************************************************************************
#**
#**  Summary  :  Cybran T2 Combat Engineer Script
#**
#****************************************************************************

local CConstructionUnit = import('/lua/cybranunits.lua').CConstructionUnit
local CDFElectronBolterWeapon = import('/lua/cybranweapons.lua').CDFElectronBolterWeapon

SRL0119 = Class(CConstructionUnit) {

    Weapons = {
        Bolter = Class(CDFElectronBolterWeapon) {},
    },

    Treads = {
        ScrollTreads = true,
        BoneName = 'BRL0209',
        TreadMarks = 'tank_treads_albedo',
        TreadMarksSizeX = 0.65,
        TreadMarksSizeZ = 0.4,
        TreadMarksInterval = 0.3,
        TreadOffset = { 0, 0, 0 },
    },

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
