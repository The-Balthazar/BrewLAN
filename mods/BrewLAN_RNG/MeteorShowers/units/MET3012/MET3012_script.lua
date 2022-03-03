local AirUnit = import('/lua/defaultunits.lua').AirUnit
local DefaultProjectileWeapon = import('/lua/sim/DefaultWeapons.lua').DefaultProjectileWeapon
local R, Ceil = Random, math.ceil
MET3012 = Class(AirUnit) {
    Weapons = {
        MeteorSmall01 = Class(DefaultProjectileWeapon){},
    },

    OnStopBeingBuilt = function(self, builder, layer)
        AirUnit.OnStopBeingBuilt(self, builder, layer)
        self:ForkThread(
            function()
                self.AimingNode = CreateRotator(self, 0, 'x', 90, 10000, 10000, 1000)
                WaitFor(self.AimingNode)
                while true do
                    local num = Ceil((R()+R()+R()+R()+R()+R()+R()+R()+R()+R()+R())*R(1,10))
                    coroutine.yield(num)
                    self:GetWeaponByLabel'MeteorSmall01':FireWeapon()
                end
            end
        )
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
    end,

    OnDamage = function()
    end,
}

TypeClass = MET3012
