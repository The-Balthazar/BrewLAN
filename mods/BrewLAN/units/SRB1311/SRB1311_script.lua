#****************************************************************************
#**
#**  File     :  /cdimage/units/URB1301/URB1301_script.lua
#**  Author(s):  John Comes, Dave Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Power Generator Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CEnergyCreationUnit = import('/lua/cybranunits.lua').CEnergyCreationUnit       
local EffectUtil = import('/lua/EffectUtilities.lua')

SRB1311 = Class(CEnergyCreationUnit) {
    
    OnStopBeingBuilt = function(self, builder, layer)
        CEnergyCreationUnit.OnStopBeingBuilt(self, builder, layer)
        self:SetMaintenanceConsumptionActive()
        self:SetScriptBit('RULEUTC_CloakToggle', false)
    end,      
     
    OnIntelEnabled = function(self)
        CEnergyCreationUnit.OnIntelEnabled(self)
        if self.IntelEffects and not self.IntelFxOn then
			self.IntelEffectsBag = {}
			self.CreateTerrainTypeEffects( self, self.IntelEffects, 'FXIdle',  self:GetCurrentLayer(), nil, self.IntelEffectsBag )
			self.IntelFxOn = true
		end
    end,

    OnIntelDisabled = function(self)
        CEnergyCreationUnit.OnIntelDisabled(self)
        EffectUtil.CleanupEffectBag(self,'IntelEffectsBag')
        self.IntelFxOn = false
    end,    
    
    IntelEffects = {
		{
			Bones = {
				'SRB1311',
			},
			Offset = {
				1.5,
				3,
				0,
			},                        
			Scale = 5,
			Type = 'Cloak01',
		},      
		{
			Bones = {
				'SRB1311',
			},
			Offset = {
				-1.5,
				3,
				0,
			},                  
			Scale = 5,
			Type = 'Cloak01',
		},
    },
}
        
TypeClass = SRB1311
