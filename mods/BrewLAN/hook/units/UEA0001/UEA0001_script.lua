local UEA0001Old = UEA0001

UEA0001 = Class(UEA0001Old) {
    OnKilled = function(self, instigator, type, overkillRatio)
        if self.Parent and not self.Parent:IsDead() then
            UEA0001Old.OnKilled(self, instigator, type, overkillRatio)
        else
            TConstructionUnit.OnKilled(self, instigator, type, overkillRatio)
        end
    end,
}

TypeClass = UEA0001
