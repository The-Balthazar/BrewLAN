local SMassStorageUnit = import('/lua/seraphimunits.lua').SMassStorageUnit

SSB1206 = Class(SMassStorageUnit) {
    OnStopBeingBuilt = function(self,builder,layer)
        SMassStorageUnit.OnStopBeingBuilt(self,builder,layer)
        self.Trash:Add(CreateStorageManip(self, 'B01', 'MASS', 0, 0, -0.75, 0, 0, 0))
    end,
}

TypeClass = SSB1206
