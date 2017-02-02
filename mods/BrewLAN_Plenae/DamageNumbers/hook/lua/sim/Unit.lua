do
    local UnitOld = Unit

    Unit = Class(UnitOld) {
        DoTakeDamage = function(self, instigator, amount, vector, damageType)
            FloatingEntityText(self:GetEntityId(),tostring(amount))
            UnitOld.DoTakeDamage(self, instigator, amount, vector, damageType)
        end,
    }
end
