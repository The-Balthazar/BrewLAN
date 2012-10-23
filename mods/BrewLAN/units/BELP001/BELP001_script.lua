#****************************************************************************
#**
#**  File     :  units/XRL0005/XRL0005_script.lua
#**
#**  Summary  :  Crab egg
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CConstructionEggUnit = import('/lua/cybranunits.lua').CConstructionEggUnit

BELP001 = Class(CConstructionEggUnit) {

    OnStopBeingBuilt = function(self, builder, layer)
        CConstructionEggUnit.OnStopBeingBuilt(self,builder,layer)
        self:Destroy()
    end,
}

TypeClass = BELP001