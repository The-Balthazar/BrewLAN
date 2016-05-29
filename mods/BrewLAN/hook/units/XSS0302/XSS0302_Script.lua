local SSeaUnit = XSS0302

XSS0302 = Class(SSeaUnit) {
    OnCreate = function(self)
        SSeaUnit.OnCreate(self) 
        if table.find(ScenarioInfo.Options.RestrictedCategories, 'NUKE') then
            self:SetWeaponEnabledByLabel('InainoMissiles', false)
        end
    end,
}

TypeClass = XSS0302
