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
		  UnitOld.OnStartBuild(self, unitBeingBuilt, order)
    end,

    OnStopBuild = function(self, unitBeingBuilt)
        if self.CouldntStop then
            self:RemoveCommandCap('RULEUCC_Stop')
            self.CouldntStop = false
        end  
        UnitOld.OnStopBuild(self, unitBeingBuilt)
    end,

    OnFailedToBuild = function(self)
        if self.CouldntStop then
            self:RemoveCommandCap('RULEUCC_Stop')
            self.CouldntStop = false
        end  
        UnitOld.OnFailedToBuild(self)
    end,
}

