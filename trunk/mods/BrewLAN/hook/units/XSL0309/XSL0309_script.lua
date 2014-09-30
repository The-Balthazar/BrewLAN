#****************************************************************************
#**
#**  Summary  :  Engineer Build Category Cheating
#**
#****************************************************************************

local ConstructionUnit = import('/units/XSL0309/XSL0309_script.lua').XSL0309

XSL0309 = Class(ConstructionUnit) {
    OnStopBeingBuilt = function(self, builder, layer)
        ConstructionUnit.OnStopBeingBuilt(self, builder, layer)
        if self:GetAIBrain().BrainType == 'Human' then
            self:AddBuildRestriction(categories.BUILTBYTIER1FIELD)
            self:AddBuildRestriction(categories.BUILTBYTIER2FIELD)
            self:AddBuildRestriction(categories.BUILTBYTIER3FIELD)
        end
    end,
}

TypeClass = XSL0309