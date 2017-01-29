do
    local UnitOld = Unit

    Unit = Class(UnitOld) {
        OnStartBuild = function(self, unitBeingBuilt, order, ...)
            local myBp = self:GetBlueprint()
            if myBp.General.UpgradesTo and unitBeingBuilt:GetUnitId() == myBp.General.UpgradesTo and order == 'Upgrade' then
                if not myBp.General.CommandCaps.RULEUCC_Stop then
                    self:AddCommandCap('RULEUCC_Stop')
                    self.CouldntStop = true
                end
            end
            return UnitOld.OnStartBuild(self, unitBeingBuilt, order, unpack(arg))
        end,

        OnStopBuild = function(self, unitBeingBuilt, ...)
            if self.CouldntStop then
                self:RemoveCommandCap('RULEUCC_Stop')
                self.CouldntStop = false
            end
            return UnitOld.OnStopBuild(self, unitBeingBuilt, unpack(arg))
        end,

        OnFailedToBuild = function(self, ...)
            if self.CouldntStop then
                self:RemoveCommandCap('RULEUCC_Stop')
                self.CouldntStop = nil
            end
            return UnitOld.OnFailedToBuild(self, unpack(arg))
        end,

        OnDamage = function(self, instigator, amount, vector, damageType, ...)
            if EntityCategoryContains(categories.BOMBER, self) and self:GetCurrentLayer() == 'Air' and damageType == 'NormalBomb' then
                UnitOld.OnDamage(self, instigator, amount * 0.05 , vector, damageType, unpack(arg))
            else
                UnitOld.OnDamage(self, instigator, amount, vector, damageType, unpack(arg))
            end
        end,
    }
end
