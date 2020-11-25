local TRadarUnit = import('/lua/terranunits.lua').TRadarUnit
local AnimationThread = import('/lua/effectutilities.lua').IntelDishAnimationThread

SEB3301 = Class(TRadarUnit) {
    OnStopBeingBuilt = function(self, ...)
        TRadarUnit.OnStopBeingBuilt(self, unpack(arg) )
        self:ForkThread(AnimationThread,{
            {
                'Med_Dish_Stand_00',
                'Med_Dish_00',
                c = 1,
                bounds = {-180,180,-90,90,},
                speed = 3,
            },
        })
    end,

    OnIntelDisabled = function(self)
        TRadarUnit.OnIntelDisabled(self)
        self.Intel = false
    end,

    OnIntelEnabled = function(self)
        TRadarUnit.OnIntelEnabled(self)
        self.Intel = true
    end,
}

TypeClass = SEB3301
