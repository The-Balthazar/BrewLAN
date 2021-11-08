local BrewLANEnergyStorageUnit = import('/lua/defaultunits.lua').BrewLANEnergyStorageUnit

SEB1205 = Class(BrewLANEnergyStorageUnit) {

    OnCreate = function(self)
        BrewLANEnergyStorageUnit.OnCreate(self)
        self.Trash:Add(CreateStorageManip(self, 'B01', 'ENERGY', 0, 0, -0.6, 0, 0, 0))
    end,
}

TypeClass = SEB1205
