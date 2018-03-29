local TRadarUnit = import('/lua/terranunits.lua').TRadarUnit

SEB3301 = Class(TRadarUnit) {

    OnIntelDisabled = function(self)
        TRadarUnit.OnIntelDisabled(self)
        --self.UpperRotator:SetTargetSpeed(0)
    end,

    OnIntelEnabled = function(self)
        TRadarUnit.OnIntelEnabled(self)
        --[[if not self.UpperRotator then
            self.UpperRotator = CreateRotator(self, 'Upper_Array', 'z')
            self.Trash:Add(self.UpperRotator)
        end
        self.UpperRotator:SetTargetSpeed(10)
        self.UpperRotator:SetAccel(5)]]--
    end,
}
TypeClass = SEB3301
