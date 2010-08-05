#****************************************************************************
#**
#**  File     :  BEA0310/BEA0310_script.lua
#**
#**  Summary  :  UEF Decoy Plane Script
#**
#****************************************************************************

local TAirUnit = import('/lua/terranunits.lua').TAirUnit

BEA0310 = Class(TAirUnit) {

    OnStopBeingBuilt = function(self,builder,layer)
        TAirUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetMaintenanceConsumptionActive()
    end,
}

TypeClass = BEA0310