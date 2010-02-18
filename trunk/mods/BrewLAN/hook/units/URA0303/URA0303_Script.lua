do
#****************************************************************************
#**
#**  File     :  /hook/units/URA0303/URA0303_script.lua
#**  Author(s):  Sean Wheeldon (Balthazar)
#**
#**  Summary  :  Auto activation of Cybran Air Superiority stealth
#**
#**  Copyright © 2010 BrewLAN.  All rights reserved.
#****************************************************************************

local CybranASF = URA0303

URA0303 = Class(CybranASF) {

    OnStopBeingBuilt = function(self,builder,layer)
        CAirUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetMaintenanceConsumptionActive()
    end,
    
}

TypeClass = URA0303

end