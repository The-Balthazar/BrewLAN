#****************************************************************************
#**
#**  File     :  /cdimage/units/XRB0304/XRB0304_script.lua
#**  Author(s):  Dru Staltman, Gordon Duclos
#**
#**  Summary  :  Cybran Engineering tower
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local CConstructionStructureUnitBase = import('/lua/cybranunits.lua').CConstructionStructureUnit
local CConstructionStructureUnit = XRB0304
XRB0304 = Class(CConstructionStructureUnit) 
{
    OnStartBeingBuilt = function(self, builder, layer)
        if builder:GetBlueprint().BlueprintId == 'xrb0204' then
            CConstructionStructureUnit.OnStartBeingBuilt(self, builder, layer)
        else 
            CConstructionStructureUnitBase.OnStartBeingBuilt(self, builder, layer)
        end
    end,
}
TypeClass = XRB0304
