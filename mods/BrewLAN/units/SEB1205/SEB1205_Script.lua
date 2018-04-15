local TEnergyStorageUnit = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/defaultunits.lua').BrewLANEnergyStorageUnit

SEB1205 = Class(TEnergyStorageUnit) {

    OnCreate = function(self)
        TEnergyStorageUnit.OnCreate(self)
        self.Trash:Add(CreateStorageManip(self, 'B01', 'ENERGY', 0, 0, -0.6, 0, 0, 0))
    end,
}

TypeClass = SEB1205
