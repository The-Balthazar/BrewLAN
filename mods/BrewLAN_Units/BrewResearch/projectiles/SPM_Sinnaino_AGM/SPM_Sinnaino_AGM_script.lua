local SLaanseTacticalMissile = import('/lua/seraphimprojectiles.lua').SLaanseTacticalMissile

SPM_Sinnaino_AGM = Class(SLaanseTacticalMissile) {

    OnCreate = function(self)
        SLaanseTacticalMissile.OnCreate(self)
        self:SetCollisionShape('Sphere', 0, 0, 0, 2.0)
        self:ForkThread( self.MovementThread )
    end,

}

TypeClass = SPM_Sinnaino_AGM
