local AMassStorageUnit = import('/lua/aeonunits.lua').AMassStorageUnit

SAB1206 = Class(AMassStorageUnit) {

    OnCreate = function(self)
        AMassStorageUnit.OnCreate(self)
        self:SetCollisionShape(
            'Sphere',
            __blueprints.sab1205.CollisionSphereOffsetX or 0,
            __blueprints.sab1205.CollisionSphereOffsetY or 0,
            __blueprints.sab1205.CollisionSphereOffsetZ or 0,
            __blueprints.sab1205.SizeSphere
        )
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        AMassStorageUnit.OnStopBeingBuilt(self,builder,layer)
        local s = 23
        for i = 1, 5 do
            if i == 2 then s = 5.75 end
            self.Trash:Add(CreateStorageManip(self, 'B0'..i, 'MASS', 0, 0, 0, 0, s * __blueprints.sab1206.Display.UniformScale, 0))
        end
    end,
}

TypeClass = SAB1206
