local PhotoUnitOld = Unit

Unit = Class(UnitOld) {    
    OnCreate = function(self)
        if self:GetBlueprint().Display.Tarmacs[1].Albedo and self:GetCurrentLayer() == 'Land' then   
            self:CreateTarmac(true, true, true, false, false)
        end
        PhotoUnitOld.OnCreate(self)      
    end,
}
