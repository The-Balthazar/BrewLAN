local TLandFactoryUnit = import('/lua/terranunits.lua').TLandFactoryUnit

SEB9301 = Class(TLandFactoryUnit) {
    OnCreate = function(self)
        TLandFactoryUnit.OnCreate(self)
    end,
}

TypeClass = SEB9301
