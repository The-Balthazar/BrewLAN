local CRadarUnit = import('/lua/cybranunits.lua').CRadarUnit
local AnimationThread = import('/lua/effectutilities.lua').IntelDishAnimationThread

SRB3301 = Class(CRadarUnit) {
    OnStopBeingBuilt = function(self, ...)
        CRadarUnit.OnStopBeingBuilt(self, unpack(arg) )
        self:ForkThread(AnimationThread,{
            {
                'Yaw_Pivot',
                'Yaw_Pivot',
                --c = 1,
                bounds = {-180,180,0,0,},
                speed = 3,
            },
        })
    end,

    OnIntelDisabled = function(self)
        CRadarUnit.OnIntelDisabled(self)
        self.Intel = false
    end,

    OnIntelEnabled = function(self)
        CRadarUnit.OnIntelEnabled(self)
        self.Intel = true
    end,
}

TypeClass = SRB3301
