do
    local UnitOld = Unit

    Unit = Class(UnitOld) {
        DoTakeDamage = function(self, instigator, amount, vector, damageType)
            if IsUnit(instigator) then
                FloatingEntityText(instigator:GetEntityId(),string.rep(' ', math.random(0,5)) .. tostring(amount) .. string.rep(' ', math.random(0,5)))
            end
            if IsUnit(self) then
                FloatingEntityText(self:GetEntityId(),string.rep(' ', math.random(0,5)) .. tostring(amount) .. string.rep(' ', math.random(0,5)))
            end
            UnitOld.DoTakeDamage(self, instigator, amount, vector, damageType)
        end,
    }
end
