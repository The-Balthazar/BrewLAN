#****************************************************************************
#**
#**  File     :  /cdimage/units/BRL0209/BRL0209_script.lua
#**  Author(s):  Sean Wheeldon
#**
#**  Summary  :  Cybran T2 Combat Engineer Script, Based on the UEF script
#**
#****************************************************************************

local EffectTemplate = import('/lua/EffectTemplates.lua')
local CConstructionUnit = import('/lua/cybranunits.lua').CConstructionUnit
local CDFElectronBolterWeapon = CybranWeaponsFile.CDFElectronBolterWeapon

BRL0209 = Class(CConstructionUnit) {

    Weapons = {
        Bolter = Class(CDFElectronBolterWeapon) {},
    },

    Treads = {
        ScrollTreads = true,
        BoneName = 'URL0208',
        TreadMarks = 'tank_treads_albedo',
        TreadMarksSizeX = 0.65,
        TreadMarksSizeZ = 0.4,
        TreadMarksInterval = 0.3,
        TreadOffset = { 0, 0, 0 },
    },

    OnStopBeingBuilt = function(self)
        self:SetMaintenanceConsumptionActive()
        TConstructionUnit.OnStopBeingBuilt(self)
        --Rotate the antenna
        self.Rotator = CreateRotator(self, 'Antenna', 'y')
        self.Trash:Add(self.Rotator)
        self.Rotator:SetSpinDown(false)
        self.Rotator:SetTargetSpeed(30)
        self.Rotator:SetAccel(20)
    end,

    OnStartBuild = function(self, unitBeingBuilt, order)
        --Disable the gun while building something
        self:SetWeaponEnabledByLabel('Bolter', false)
        TConstructionUnit.OnStartBuild(self, unitBeingBuilt, order)
    end,
    
    OnStopBuild = function(self)
        --Re-enable the gun after done building
        self:SetWeaponEnabledByLabel('Bolter', true)
        TConstructionUnit.OnStopBuild(self)
    end,
    
    OnStartReclaim = function(self, target)
        TConstructionUnit.OnStartReclaim(self, target)
        self:SetAllWeaponsEnabled(false)
    end,
    
    OnStopReclaim = function(self, target)
        TConstructionUnit.OnStopReclaim(self, target)
        self:SetAllWeaponsEnabled( true)
    end,
}
TypeClass = BRL0209