local UnitOld = Unit

Unit = Class(UnitOld) {
    OnStartBuild = function(self, unitBeingBuilt, order)
        local bp = self:GetBlueprint()
        if bp.General.UpgradesTo and unitBeingBuilt:GetUnitId() == bp.General.UpgradesTo and order == 'Upgrade' then
            if not bp.General.CommandCaps.RULEUCC_Stop then
                self:AddCommandCap('RULEUCC_Stop')
                self.CouldntStop = true
            end
        end
        --if order == 'Repair' and unitBeingBuilt.WreckMassMult then
        --    self.Rezrepairing = true
        --elseif self.Rezrepairing then      
        --    self.Rezrepairing = false        
        --end       
        UnitOld.OnStartBuild(self, unitBeingBuilt, order)
    end,

    OnStopBuild = function(self, unitBeingBuilt)
        if self.CouldntStop then
            self:RemoveCommandCap('RULEUCC_Stop')
            self.CouldntStop = false
        end                      
        --if self.Rezrepairing then
        --    unitBeingBuilt.WreckMassMult = 0.9 * unitBeingBuilt:GetHealthPercent()
        --    LOG('Thing is: ',unitBeingBuilt.WreckMassMult)
        --end           
        UnitOld.OnStopBuild(self, unitBeingBuilt)
    end,

    OnFailedToBuild = function(self)
        if self.CouldntStop then
            self:RemoveCommandCap('RULEUCC_Stop')
            self.CouldntStop = false
        end       
        UnitOld.OnFailedToBuild(self)
    end,
    
    OnDamage = function(self, instigator, amount, vector, damageType)
        if EntityCategoryContains(categories.BOMBER, self) and self:GetCurrentLayer() == 'Air' and damageType == 'NormalBomb' then
            UnitOld.OnDamage(self, instigator, amount * 0.05 , vector, damageType)
        else
            UnitOld.OnDamage(self, instigator, amount, vector, damageType)
        end
    end, 
}

