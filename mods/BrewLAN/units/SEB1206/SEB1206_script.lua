--------------------------------------------------------------------------------
--  Summary  :  UEF Mass Storage
--------------------------------------------------------------------------------
local TMassStorageUnit = import('/lua/terranunits.lua').TMassStorageUnit

SEB1206 = Class(TMassStorageUnit) {

    OnStopBeingBuilt = function(self,builder,layer)
        TMassStorageUnit.OnStopBeingBuilt(self,builder,layer)
        self.Trash:Add(CreateStorageManip(self, 'Block', 'MASS', 0, -.4, 0, 0, 0, 0))
    end,
}

TypeClass = SEB1206
