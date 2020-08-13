local UEA0003Old = UEA0003

UEA0003 = Class(UEA0003Old) {
    OnKilled = function(self, instigator, type, overkillRatio)
        if self.Parent and not self.Parent:IsDead() then
            UEA0003Old.OnKilled(self, instigator, type, overkillRatio)
        else
            TConstructionUnit.OnKilled(self, instigator, type, overkillRatio)
        end
    end,
}

TypeClass = UEA0003
