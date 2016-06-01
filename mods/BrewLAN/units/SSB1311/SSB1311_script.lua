#****************************************************************************
#**
#**  File     :  /data/units/XSB1301/XSB1301_script.lua
#**  Author(s):  Jessica St. Croix, Greg Kohne
#**
#**  Summary  :  Seraphim T3 Power Generator Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local SEnergyCreationUnit = import('/lua/seraphimunits.lua').SEnergyCreationUnit

SSB1311 = Class(SEnergyCreationUnit) {
    AmbientEffects = 'ST3PowerAmbient',
    
    OnStopBeingBuilt = function(self, builder, layer)
        SEnergyCreationUnit.OnStopBeingBuilt(self, builder, layer)
        self.Trash:Add(CreateRotator(self, 'Orb', 'y', nil, 0, 15, 80 + Random(0, 20)))
    end,
}

TypeClass = SSB1311
