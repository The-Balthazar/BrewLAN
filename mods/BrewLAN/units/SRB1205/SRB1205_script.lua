local CEnergyStorageUnit = import('/lua/defaultunits.lua').BrewLANEnergyStorageUnit

SRB1205 = Class(CEnergyStorageUnit) {
    DestructionPartsChassisToss = {'SRB1205'},

    OnStopBeingBuilt = function(self,builder,layer)
        CEnergyStorageUnit.OnStopBeingBuilt(self,builder,layer)
        local myBlueprint = self:GetBlueprint()
        if myBlueprint.Audio.Activate then
            self:PlaySound(myBlueprint.Audio.Activate)
        end
        self.Trash:Add(CreateStorageManip(self, 'Lift', 'ENERGY', 0, 0, 0, 0, .8, 0))
    end,
}

TypeClass = SRB1205
