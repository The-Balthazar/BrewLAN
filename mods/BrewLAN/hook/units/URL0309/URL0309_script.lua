#****************************************************************************
#**
#**  Summary  :  Engineer Build Category Cheating
#**
#****************************************************************************

local ConstructionUnit = import('/units/URL0309/URL0309_script.lua').URL0309

URL0309 = Class(ConstructionUnit) {
    OnStopBeingBuilt = function(self, builder, layer)
        ConstructionUnit.OnStopBeingBuilt(self, builder, layer)
        if self:GetAIBrain().BrainType == 'Human' then
            self:AddBuildRestriction(categories.BUILTBYTIER1FIELD)
            self:AddBuildRestriction(categories.BUILTBYTIER2FIELD)
            self:AddBuildRestriction(categories.BUILTBYTIER3FIELD)
        end
    end,
}

TypeClass = URL0309