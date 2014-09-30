#****************************************************************************
#**
#**  Summary  :  Engineer Build Category Cheating
#**
#****************************************************************************
--For some reason the dipshits defined UEL0309 as a local variable, so I can't reference it.
--local ConstructionUnit = import('/units/UEL0309/UEL0309_script.lua').UEL0309

local ConstructionUnit = import('/lua/terranunits.lua').TConstructionUnit

UEL0309 = Class(ConstructionUnit) {
    OnStopBeingBuilt = function(self, builder, layer)
        ConstructionUnit.OnStopBeingBuilt(self, builder, layer)
        if self:GetAIBrain().BrainType == 'Human' then
            self:AddBuildRestriction(categories.BUILTBYTIER1FIELD)
            self:AddBuildRestriction(categories.BUILTBYTIER2FIELD)
            self:AddBuildRestriction(categories.BUILTBYTIER3FIELD)
        end
    end,
}

TypeClass = UEL0309