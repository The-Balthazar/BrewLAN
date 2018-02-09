local TLandFactoryUnit = UEB0101

UEB0101 = Class(TLandFactoryUnit) {

    OnStopBeingBuilt = function(self, builder, layer)
        local pos = self:GetPosition()
        self.Spawn = CreateUnitHPR(
            'seb0101',
            self:GetAIBrain().Name,
            pos[1], pos[2], pos[3],
            0, 0, 0
        )
        self:Destroy()
        TLandFactoryUnit.OnStopBeingBuilt(self,builder,layer)
    end,

}

TypeClass = UEB0101
