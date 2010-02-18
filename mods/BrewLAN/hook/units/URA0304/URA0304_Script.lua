do
#****************************************************************************
#**
#**  File     :  /hook/units/URA0304/URA0304_script.lua
#**  Author(s):  Sean Wheeldon (Balthazar)
#**
#**  Summary  :   Auto activation of Cybran Strategic Bomber Script stealth
#**
#**  Copyright © 2010 BrewLAN.  All rights reserved.
#****************************************************************************

local CybranStratBomber = URA0304

URA0304 = Class(CybranStratBomber) {

    OnStopBeingBuilt = function(self,builder,layer)
        CAirUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetMaintenanceConsumptionActive()
    end,
}
TypeClass = URA0304

end