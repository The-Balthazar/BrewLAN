local CIridiumRocketProjectile = import('/lua/cybranprojectiles.lua').CIridiumRocketProjectile

CPM_Tyrant_AGM = Class(CIridiumRocketProjectile) {

    OnCreate = function(self)
        CIridiumRocketProjectile.OnCreate(self)
        self:SetCollisionShape('Sphere', 0, 0, 0, 2)
    end,

}

TypeClass = CPM_Tyrant_AGM
