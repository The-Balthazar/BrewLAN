#****************************************************************************
#**
#**  File     :  /cdimage/units/URB4203/URB4203_script.lua
#**  Author(s):  David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Radar Jammer Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CRadarJammerUnit = import('/lua/cybranunits.lua').CRadarJammerUnit

SRB4313 = Class(CRadarJammerUnit) {
    OnStopBeingBuilt = function(self,builder,layer)
        CRadarJammerUnit.OnStopBeingBuilt(self,builder,layer)
        if not self.TowerSlider then
            self.TowerSlider = CreateSlider(self, 'Tower')
            self.Trash:Add(self.TowerSlider)
            self.TowerSlider:SetGoal(0, 0, -6.2)
            self.TowerSlider:SetSpeed(2)
        end
    end,

    OnIntelEnabled = function(self)
        CRadarJammerUnit.OnIntelEnabled(self)

            if not self.TowerSlider then return end
            self.TowerSlider:SetGoal(0, 0, -6.2)
            self.TowerSlider:SetSpeed(2)
    end,

    OnIntelDisabled = function(self)
        CRadarJammerUnit.OnIntelDisabled(self)

            self.TowerSlider:SetGoal(0, 0, 0)
            self.TowerSlider:SetSpeed(2)
    end,    

    IntelEffects = {
		{
			Bones = {
				'Emitter',
			},
			Offset = {
				0,
				0,
				0,
			},
			Type = 'Jammer01',
		},
    },
}

TypeClass = SRB4313
