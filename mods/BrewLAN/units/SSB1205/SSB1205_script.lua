local SEnergyStorageUnit = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/defaultunits.lua').BrewLANEnergyStorageUnit

XSB1105 = Class(SEnergyStorageUnit) {

    OnStopBeingBuilt = function(self,builder,layer)
        SEnergyStorageUnit.OnStopBeingBuilt(self,builder,layer)
        self.Trash:Add(CreateStorageManip(self, 'B01', 'ENERGY', 0, 0, -.88, 0, 0, 0))
    end,
}

TypeClass = XSB1105
