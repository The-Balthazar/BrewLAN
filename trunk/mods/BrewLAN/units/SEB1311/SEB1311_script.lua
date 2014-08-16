#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB1301/UEB1301_script.lua
#**  Author(s):  John Comes, Dave Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Tier 3 Power Generator Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TEnergyCreationUnit = import('/lua/terranunits.lua').TEnergyCreationUnit

SEB1311 = Class(TEnergyCreationUnit) {
    OnStopBeingBuilt = function(self,builder,layer)
        TEnergyCreationUnit.OnStopBeingBuilt(self,builder,layer)   
        self:SetMaintenanceConsumptionActive()
        self:SetScriptBit('RULEUTC_CloakToggle', false)
        ChangeState(self, self.ActiveState)
    end,

    ActiveState = State {
        Main = function(self)
            # Play the "activate" sound
            local myBlueprint = self:GetBlueprint()
            if myBlueprint.Audio.Activate then
                self:PlaySound(myBlueprint.Audio.Activate)
            end
        end,

        OnInActive = function(self)
            ChangeState(self, self.InActiveState)
        end,
    },

    InActiveState = State {
        Main = function(self)
        end,

        OnActive = function(self)
            ChangeState(self, self.ActiveState)
        end,
    },      
     
    OnIntelEnabled = function(self)
        TEnergyCreationUnit.OnIntelEnabled(self)
        if self.IntelEffects and not self.IntelFxOn then
			self.IntelEffectsBag = {}
			self.CreateTerrainTypeEffects( self, self.IntelEffects, 'FXIdle',  self:GetCurrentLayer(), nil, self.IntelEffectsBag )
			self.IntelFxOn = true
		end
    end,

    OnIntelDisabled = function(self)
        TEnergyCreationUnit.OnIntelDisabled(self)
        EffectUtil.CleanupEffectBag(self,'IntelEffectsBag')
        self.IntelFxOn = false
    end,    
    
    IntelEffects = {
		{
			Bones = {
				0,
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
				0,
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

TypeClass = SEB1311