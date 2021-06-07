do
    local UnitOld = Unit

    Unit = Class(UnitOld) {

        OnPreCreate = function(self)
            UnitOld.OnPreCreate(self)
            if not self.BpId then self.BpId = self:GetBlueprint().BlueprintId end
        end,

        OnDamage = function(self, instigator, amount, vector, damageType, ...)
            local layer = self:GetCurrentLayer()
            if damageType == 'NormalAboveWater' and (layer == 'Sub' or layer == 'Seabed') then
                local bp = __blueprints[self.BpId]
                local damagetotal = amount / math.max(math.abs(vector[2]) - (bp.SizeY or 1) - (bp.CollisionOffsetY or 1), 1)
                UnitOld.OnDamage(self, instigator, damagetotal, vector, damageType, unpack(arg))
            else
                UnitOld.OnDamage(self, instigator, amount, vector, damageType, unpack(arg))
            end
        end,
    }
end
