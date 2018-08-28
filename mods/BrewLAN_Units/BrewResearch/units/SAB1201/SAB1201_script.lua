local AEnergyCreationUnit = import('/lua/aeonunits.lua').AEnergyCreationUnit
local AT2PowerAmbient = import('/lua/EffectTemplates.lua').AT2PowerAmbient
SAB1201 = Class(AEnergyCreationUnit) {

    OnStopBeingBuilt = function(self,builder,layer)
        AEnergyCreationUnit.OnStopBeingBuilt(self, builder, layer)
        local army =  self:GetArmy()
        for k, v in AT2PowerAmbient do
            CreateAttachedEmitter(self, 0, army, v):ScaleEmitter(0.8)
        end
    end,
}

TypeClass = SAB1201
