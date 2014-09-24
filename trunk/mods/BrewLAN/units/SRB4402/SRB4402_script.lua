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

SRB4402 = Class(CRadarJammerUnit) {
    OnStopBeingBuilt = function(self,builder,layer)
        CRadarJammerUnit.OnStopBeingBuilt(self,builder,layer)
    end,

    OnIntelEnabled = function(self)
        CRadarJammerUnit.OnIntelEnabled(self)
    end,

    OnIntelDisabled = function(self)
        CRadarJammerUnit.OnIntelDisabled(self)
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

TypeClass = SRB4402