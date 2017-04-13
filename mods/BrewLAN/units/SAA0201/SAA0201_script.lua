#****************************************************************************
#**
#**  File     :  /cdimage/units/UAA0302/UAA0302_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Aeon Spy Plane Script
#**
#**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AAirUnit = import('/lua/aeonunits.lua').AAirUnit

SAA0201 = Class(AAirUnit) {
    OnScriptBitSet = function(self, bit)
        AAirUnit.OnScriptBitSet(self, bit)
        if bit == 1 then

            ##local CZARmove = GetBlueprint(all_bps.Unit.uaa0310.Air)

            self:SetSpeedMult(0.26666666666667)     # change the speed of the unit by this mult
            self:SetAccMult(0.25)       # change the acceleration of the unit by this mult
            self:SetTurnMult(0.25)      # change the turn ability of the unit by this mult
        end
    end,
    OnScriptBitClear = function(self, bit)
        AAirUnit.OnScriptBitClear(self, bit)
        if bit == 1 then
            self:SetSpeedMult(1)
            self:SetAccMult(1)
            self:SetTurnMult(1)
        end
    end,
}
TypeClass = SAA0201
