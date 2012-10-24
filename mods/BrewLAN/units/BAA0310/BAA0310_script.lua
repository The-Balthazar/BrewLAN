#****************************************************************************
#**
#**  File     :  /cdimage/units/UAA0302/UAA0302_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Aeon Spy Plane Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AAirUnit = import('/lua/aeonunits.lua').AAirUnit

BAA0310 = Class(AAirUnit) {
    OnScriptBitSet = function(self, bit)
        AAirUnit.OnScriptBitSet(self, bit)
        if bit == 6 then
            local CZARmove = GetBlueprint(all_bps.Unit.uaa0310.Air)
	    ##--Fuck, what do here.
        end
    end,
    OnScriptBitClear = function(self, bit)
        AAirUnit.OnScriptBitClear(self, bit)
        if bit == 6 then
        end
    end,
}
TypeClass = BAA0310