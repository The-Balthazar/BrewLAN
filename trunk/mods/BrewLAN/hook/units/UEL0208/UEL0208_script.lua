#****************************************************************************
#**
#**  Summary  :  Engineer Build Category Cheating
#**
#****************************************************************************

local ConstructionUnit = import('/units/UEL0208/UEL0208_script.lua').UEL0208

UEL0208 = Class(ConstructionUnit) {
    OnStopBeingBuilt = function(self, builder, layer)
        ConstructionUnit.OnStopBeingBuilt(self, builder, layer)
        if self:GetAIBrain().BrainType == 'Human' then
            self:AddBuildRestriction(categories.BUILTBYTIER1FIELD)
            self:AddBuildRestriction(categories.BUILTBYTIER2FIELD)
            self:AddBuildRestriction(categories.BUILTBYTIER3FIELD)
        end
    end,
}

TypeClass = UEL0208