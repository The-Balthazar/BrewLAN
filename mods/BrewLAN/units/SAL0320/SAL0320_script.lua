local ALandUnit = import('/lua/aeonunits.lua').ALandUnit
local ADFAlchemistPhasonLaser = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/weapons.lua').ADFAlchemistPhasonLaser

SAL0320 = Class(ALandUnit) {
    KickupBones = {},
    
    Weapons = {
        AAGun = Class(ADFAlchemistPhasonLaser) {},
    },
    
    OnCreate = function(self)
        ALandUnit.OnCreate(self)
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        ALandUnit.OnStopBeingBuilt(self,builder,layer)
        self.rotators = {
            CreateRotator(self, 'Sphere', 'x', math.random(-30, 30) ),
            CreateRotator(self, 'Sphere', 'y', math.random(-30, 30)),
            CreateRotator(self, 'Sphere', 'z', nil, 0, 45, (-1 + 2 * math.random(0,1) ) * 45),
            CreateRotator(self, 'Rule', 'x', math.random(-30, 30) ),
            CreateRotator(self, 'Rule', 'y', math.random(-30, 30)),
            CreateRotator(self, 'Rule', 'z', nil, 0, 45, (-1 + 2 * math.random(0,1) ) * 25),
            CreateRotator(self, 'Orb', 'x', nil, 0, 45, (-1 + 2 * math.random(0,1) ) * 35),
            CreateRotator(self, 'Orb', 'y', nil, 0, 45, (-1 + 2 * math.random(0,1) ) * 35),
            CreateRotator(self, 'Orb', 'z', nil, 0, 45, (-1 + 2 * math.random(0,1) ) * 35),
        }
    end,    
}

TypeClass = SAL0320