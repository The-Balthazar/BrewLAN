#****************************************************************************
#**
#**  Summary  :  UEF Decoy Plane Script
#**
#****************************************************************************

local TAirUnit = import('/lua/terranunits.lua').TAirUnit

SEA0310 = Class(TAirUnit) {

    OnStopBeingBuilt = function(self,builder,layer)
        TAirUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetMaintenanceConsumptionActive()
    end,
}

TypeClass = SEA0310
