local ALandUnit = import('/lua/aeonunits.lua').ALandUnit
local ADFAlchemistPhasonLaser = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/weapons.lua').ADFAlchemistPhasonLaser

SAL0320 = Class(ALandUnit) {
    KickupBones = {},

    Weapons = {AAGun = Class(ADFAlchemistPhasonLaser) {}},

    OnStopBeingBuilt = function(self,builder,layer)
        ALandUnit.OnStopBeingBuilt(self,builder,layer)
        self.rotators = {}
        for _, bone in {'Sphere', 'Rule', 'Orb'} do
            for _, ori in {'x','y','z'} do
                if (ori == 'x' or ori =='y') and (bone == 'Sphere' or bone == 'Rule') then
                    table.insert(self.rotators, CreateRotator(self, bone, ori, math.random(-30, 30) ) )
                else
                    local mult = 45
                    if bone == 'Rule' then mult = 25 elseif bone == 'Orb' then mult = 35 end
                    table.insert(self.rotators, CreateRotator(self, bone, ori, nil, 0, 45, (-1 + 2 * math.random(0,1) ) * mult) )
                end
            end
        end
    end,
}

TypeClass = SAL0320
