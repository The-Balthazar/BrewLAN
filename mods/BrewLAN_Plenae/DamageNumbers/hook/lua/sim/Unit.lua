do
    local UnitOld = Unit

    Unit = Class(UnitOld) {
        DoTakeDamage = function(self, instigator, amount, vector, damageType)
            FloatingEntityText(self:GetEntityId(),string.rep(' ', math.random(0,5)) .. tostring(amount) .. string.rep(' ', math.random(0,5)))
            FloatingEntityText(instigator:GetEntityId(),string.rep(' ', math.random(0,5)) .. tostring(amount) .. string.rep(' ', math.random(0,5)))
            UnitOld.DoTakeDamage(self, instigator, amount, vector, damageType)
        end,
    }
end
