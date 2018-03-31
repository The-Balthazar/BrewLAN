local TRadarUnit = import('/lua/terranunits.lua').TRadarUnit

SEB3301 = Class(TRadarUnit) {

    OnIntelDisabled = function(self)
        TRadarUnit.OnIntelDisabled(self)
        --self.UpperRotator:SetTargetSpeed(0)
    end,

    OnIntelEnabled = function(self)
        TRadarUnit.OnIntelEnabled(self)
        --Steal animation from panopticon.
    end,
}
TypeClass = SEB3301
