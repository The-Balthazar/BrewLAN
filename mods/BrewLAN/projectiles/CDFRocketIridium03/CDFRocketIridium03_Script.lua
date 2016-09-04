local CIridiumRocketProjectile = import('/lua/cybranprojectiles.lua').CIridiumRocketProjectile
CDFRocketIridium03 = Class(CIridiumRocketProjectile) {
    OnImpact = function(self, targetType, targetEntity)
        CIridiumRocketProjectile.OnImpact(self, targetType, targetEntity)
        local army = self:GetArmy()
        CreateLightParticle( self, -1, army, 2, 1, 'glow_03', 'ramp_red_06' )
        CreateLightParticle( self, -1, army, 1, 3, 'glow_03', 'ramp_antimatter_02' )
        if targetType == 'Terrain' or targetType == 'Prop' then
            CreateDecal( self:GetPosition(), import('/lua/utilities.lua').GetRandomFloat(0.0,6.28), 'scorch_011_albedo', '', 'Albedo', 2, 2, 350, 200, army )  
        end        
    end,
}

TypeClass = CDFRocketIridium03
