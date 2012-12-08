#****************************************************************************
#**
#**  File     :  /cdimage/units/UAB1105/UAB1105_script.lua
#**  Author(s):  Jessica St. Croix
#**
#**  Summary  :  Aeon Energy Storage
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local AEnergyStorageUnit = import('/lua/aeonunits.lua').AEnergyStorageUnit

SAB1205 = Class(AEnergyStorageUnit) {

    OnStopBeingBuilt = function(self,builder,layer)
        AEnergyStorageUnit.OnStopBeingBuilt(self,builder,layer)
        self.Trash:Add(CreateStorageManip(self, 'Side_Pods', 'ENERGY', 0, 0, 0, 0, 0, .3*1.5))
        self.Trash:Add(CreateStorageManip(self, 'Center_Pod', 'ENERGY', 0, 0, 0, 0, 0, .3*1.5))
    end,

}

TypeClass = SAB1205