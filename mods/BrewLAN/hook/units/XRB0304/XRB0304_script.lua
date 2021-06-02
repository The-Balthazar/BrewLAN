local CConstructionStructureUnitBase = import('/lua/cybranunits.lua').CConstructionStructureUnit
local CConstructionStructureUnit = XRB0304

XRB0304 = Class(CConstructionStructureUnit) {
    OnStartBeingBuilt = function(self, builder, layer)
        if builder.BpId == 'xrb0204' then
            CConstructionStructureUnit.OnStartBeingBuilt(self, builder, layer)
        else
            CConstructionStructureUnitBase.OnStartBeingBuilt(self, builder, layer)
        end
    end,
}

TypeClass = XRB0304
