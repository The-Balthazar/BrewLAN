#****************************************************************************
#**
#**  File     :  /cdimage/units/URB1303/URB1303_script.lua
#**  Author(s):  Jessica St. Croix, David Tomandl
#**
#**  Summary  :  Cybran T3 Mass Fabricator
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CMassFabricationUnit = import('/lua/cybranunits.lua').CMassFabricationUnit
local EffectUtil = import('/lua/EffectUtilities.lua')

SRB1313 = Class(CMassFabricationUnit) {

    OnStopBeingBuilt = function(self,builder,layer)
        CMassFabricationUnit.OnStopBeingBuilt(self,builder,layer)
        self.Rotator = CreateRotator(self, 'Spinner', 'z')
        self.Rotator:SetAccel(10)
        self.Rotator:SetTargetSpeed(60)
        self.Trash:Add(self.Rotator)
        self:SetScriptBit('RULEUTC_CloakToggle', false)
        self.Prodon = true
        self:SetEnergyMaintenanceConsumptionOverride(self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergyFab + self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergyCloak or 3500)
        self:SetProductionPerSecondMass((self:GetBlueprint().Economy.ProductionPerSecondMass or 0) * (self.MassProdAdjMod or 1))
	self:SetMaintenanceConsumptionActive()  
    end,

    OnProductionUnpaused = function(self)
        CMassFabricationUnit.OnProductionUnpaused(self)
        self.Rotator:SetTargetSpeed(60)
        self.Prodon = true

		if self:IsIntelEnabled('Cloak') then
			self:SetEnergyMaintenanceConsumptionOverride(self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergyFab + self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergyCloak or 3500)
			self:SetProductionPerSecondMass((self:GetBlueprint().Economy.ProductionPerSecondMass or 0) * (self.MassProdAdjMod or 1))
			self:SetMaintenanceConsumptionActive()  
		else
			self:SetEnergyMaintenanceConsumptionOverride(self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergyFab or 2625)
			self:SetProductionPerSecondMass((self:GetBlueprint().Economy.ProductionPerSecondMass or 0) * (self.MassProdAdjMod or 1))
			self:SetMaintenanceConsumptionActive()  
		end
    end,

    OnProductionPaused = function(self)
        CMassFabricationUnit.OnProductionPaused(self)
        self.Rotator:SetTargetSpeed(0)
        self.Prodon = false

		if self:IsIntelEnabled('Cloak') then
			self:SetEnergyMaintenanceConsumptionOverride(self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergyCloak or 875)
			self:SetProductionPerSecondMass(0)
			self:SetMaintenanceConsumptionActive()
		else
			self:SetEnergyMaintenanceConsumptionOverride(0)
		end
    end,

    OnIntelEnabled = function(self)
        CMassFabricationUnit.OnIntelEnabled(self)
        if self.IntelEffects and not self.IntelFxOn then
			self.IntelEffectsBag = {}
			self.CreateTerrainTypeEffects( self, self.IntelEffects, 'FXIdle',  self:GetCurrentLayer(), nil, self.IntelEffectsBag )
			self.IntelFxOn = true
		end
		if self.Prodon then
			self:SetEnergyMaintenanceConsumptionOverride(self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergyFab + self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergyCloak or 3500)
			self:SetProductionPerSecondMass((self:GetBlueprint().Economy.ProductionPerSecondMass or 0) * (self.MassProdAdjMod or 1))
			self:SetMaintenanceConsumptionActive()  
		else
			self:SetEnergyMaintenanceConsumptionOverride(self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergyCloak or 875)
			self:SetProductionPerSecondMass(0)
			self:SetMaintenanceConsumptionActive()  
		end
    end,

    OnIntelDisabled = function(self)
        CMassFabricationUnit.OnIntelDisabled(self)
        EffectUtil.CleanupEffectBag(self,'IntelEffectsBag')
        self.IntelFxOn = false
		if self.Prodon then
			self:SetEnergyMaintenanceConsumptionOverride(self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergyFab or 2625)
			self:SetProductionPerSecondMass((self:GetBlueprint().Economy.ProductionPerSecondMass or 0) * (self.MassProdAdjMod or 1))
			self:SetMaintenanceConsumptionActive()  
		else
			self:SetEnergyMaintenanceConsumptionOverride(0)
		end
    end,    
    
    IntelEffects = {
		{
			Bones = {
				0,
			},
			Offset = {
				0,
				2,
				0,
			},                        
			Scale = 5,
			Type = 'Cloak01',
		},
    },
}

TypeClass = SRB1313
