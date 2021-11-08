local AEnergyStorageUnit = import('/lua/defaultunits.lua').BrewLANEnergyStorageUnit

SAB1205 = Class(AEnergyStorageUnit) {

    OnCreate = function(self)
        AEnergyStorageUnit.OnCreate(self)
        self:SetCollisionShape(
            'Sphere',
            __blueprints.sab1205.CollisionSphereOffsetX or 0,
            __blueprints.sab1205.CollisionSphereOffsetY or 0,
            __blueprints.sab1205.CollisionSphereOffsetZ or 0,
            __blueprints.sab1205.SizeSphere
        )
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        AEnergyStorageUnit.OnStopBeingBuilt(self,builder,layer)
        self.Trash:Add(CreateStorageManip(self, 'Slider', 'ENERGY', 0, 0, 0, 0, 23.097 * __blueprints.sab1205.Display.UniformScale, 0))
    end,
}

TypeClass = SAB1205
