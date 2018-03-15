local UnitOld = Unit

Unit = Class(UnitOld) {
    OnStopBeingBuilt = function(self, ...)
        UnitOld.OnStopBeingBuilt(self, unpack(arg) )
        self:ForkThread(self.AcidThread)
    end,

    AcidThread = function(self)
        local damage = 0
        while self do
            local layer = self:GetCurrentLayer()
            if layer == 'Water' or layer == 'Seabed' or layer == 'Sub' then
                if damage == 0 then
                    damage = GetGameTimeSeconds()
                end
                self:OnDamage(self, GetGameTimeSeconds() - damage, Vector(0,0,0), 'normal')
                WaitTicks(1)
            else
                damage = 0
                WaitSeconds(2)
            end
        end
    end,
}
