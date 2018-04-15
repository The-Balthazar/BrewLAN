local AEnergyStorageUnit = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/defaultunits.lua').BrewLANEnergyStorageUnit

SAB1205 = Class(AEnergyStorageUnit) {
    OnStopBeingBuilt = function(self,builder,layer)
        AEnergyStorageUnit.OnStopBeingBuilt(self,builder,layer)
        self.Trash:Add(CreateStorageManip(self, 'Side_Pods', 'ENERGY', 0, 0, 0, 0, 0, .3*1.5))
        self.Trash:Add(CreateStorageManip(self, 'Center_Pod', 'ENERGY', 0, 0, 0, 0, 0, .3*1.5))
    end,
}

TypeClass = SAB1205
