#
# Cybran Artillery Projectile
#
local CArtilleryProtonProjectile = import('/lua/cybranprojectiles.lua').CArtilleryProtonProjectile
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat

CIFArtilleryBeetle01 = Class(CArtilleryProtonProjectile) {

    OnCreate = function(self, ...)
        CArtilleryProtonProjectile.OnCreate(self, unpack(arg) )
        --CreateRotator(self, 0, 'x', nil, 0, math.random(30,90), math.random(-90, 90) )
        --CreateRotator(self, 0, 'y', nil, 0, math.random(30,90), math.random(-90, 90) )
        --CreateRotator(self, 0, 'z', nil, 0, math.random(30,90), math.random(-90, 90) )
    end,
    
    OnImpact = function(self, targetType, targetEntity)
        local army = self:GetArmy()
        if targetType == 'Terrain' or targetType == 'Prop' then
            local pos = self:GetPosition()
            CreateDecal( pos, RandomFloat(0.0,6.28), 'scorch_011_albedo', '', 'Albedo', 1, 1, 350, 200, army )
            local beetle = CreateUnitHPR('xrl0302',army,pos[1], pos[2], pos[3],0, math.random(0,360), 0)
            local target = self:GetCurrentTargetPosition()
            --IssueMove( {beetle},  {target[1] + Random(-3, 3), target[2], target[3]+ Random(-3, 3)} )
            local targets -- = self:GetAIBrain():GetUnitsAroundPoint(categories.ALLUNITS, target, 20, 'Enemy')
            if targets[1] then
                IssueAttack({beetle},targets[math.random(1,table.getn(targets))] )
            else
                IssueAttack({beetle},target)
            end
            beetle:SetHealth(beetle,beetle:GetHealth() * RandomFloat(0.4,0.8)  )
            CreateLightParticle( self, -1, army,2,4, 'glow_03', 'ramp_antimatter_02' )
            self:Destroy() 
        else
            CArtilleryProtonProjectile.OnImpact(self, targetType, targetEntity)
            CreateLightParticle( self, -1, army, 24, 12, 'glow_03', 'ramp_red_06' )
            CreateLightParticle( self, -1, army, 8, 22, 'glow_03', 'ramp_antimatter_02' )
        end
        ForkThread(self.ForceThread, self, self:GetPosition())
        self:ShakeCamera( 20, 3, 0, 1 )        
    end,

    ForceThread = function(self, pos)
        DamageArea(self, pos, 10, 1, 'Force', true)
        WaitTicks(2)
        DamageArea(self, pos, 10, 1, 'Force', true)
        DamageRing(self, pos, 10, 15, 1, 'Fire', true)
    end,
}
TypeClass = CIFArtilleryBeetle01