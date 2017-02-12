local AShieldStructureUnit = import('/lua/aeonunits.lua').AShieldStructureUnit

ZZZ0001 = Class(AShieldStructureUnit) {

    OnCreate = function(self)
        AShieldStructureUnit.OnCreate(self)
        LOG("POS: " .. self:GetPosition()[1] .. ", " .. self:GetPosition()[2] .. ", " .. self:GetPosition()[3])
        self.DPScalcs = {}
    end,

    DoTakeDamage = function(self, instigator, amount, vector, damageType)
        if not self.DPScalcs[instigator:GetEntityId()] then
            self.DPScalcs[instigator:GetEntityId()] = {
                startTime = GetGameTimeSeconds(),
                totalDamageSustain = 0,
                totalDamageBurst = amount,
            }
        else
            local enttable = self.DPScalcs[instigator:GetEntityId()]
            enttable.totalDamageSustain = enttable.totalDamageSustain + amount
            enttable.totalDamageBurst = enttable.totalDamageBurst + amount

            local intro = (instigator:GetBlueprint().General.UnitName or instigator:GetBlueprint().BlueprintId) .. " DPS: "
            local duration = GetGameTimeSeconds() - enttable.startTime

            if enttable.Message != math.floor(enttable.totalDamageSustain / duration + 0.5) .. " - " .. math.floor(enttable.totalDamageBurst / duration + 0.5) then
                enttable.Message = math.floor(enttable.totalDamageSustain / duration + 0.5) .. " - " .. math.floor(enttable.totalDamageBurst / duration + 0.5)
                LOG(intro .. enttable.Message )
            end
        end
        if IsUnit(instigator) then
            FloatingEntityText(instigator:GetEntityId(),string.rep(' ', math.random(0,5)) .. tostring(amount) .. string.rep(' ', math.random(0,5)))
        end
        if IsUnit(self) then
            FloatingEntityText(self:GetEntityId(),string.rep(' ', math.random(0,5)) .. tostring(amount) .. string.rep(' ', math.random(0,5)))
        end
        --AShieldStructureUnit.DoTakeDamage(self, instigator, amount, vector, damageType)
    end,
}

TypeClass = ZZZ0001
