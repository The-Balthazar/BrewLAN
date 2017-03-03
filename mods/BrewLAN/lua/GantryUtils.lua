--------------------------------------------------------------------------------
-- UI buildmode change function
--------------------------------------------------------------------------------
function BuildModeChange(self, mode)
    self:RestoreBuildRestrictions()
    ------------------------------------------------------------------------
    -- The "Stolen tech" clause
    ------------------------------------------------------------------------
    local aiBrain = self:GetAIBrain()
    local engineers = aiBrain:GetUnitsAroundPoint(categories.ENGINEER, self:GetPosition(), 30, 'Ally' )
    local stolentech = {
        CYBRAN = false,
        AEON = false,
        SERAPHIM = false,
        UEF = false,
    }
    for race, val in stolentech do
        if EntityCategoryContains(ParseEntityCategory(race), self) then
            stolentech[race] = true
        end
    end
    for k, v in engineers do
        if EntityCategoryContains(categories.TECH3, v) then
            for race, val in stolentech do
                if EntityCategoryContains(ParseEntityCategory(race), v) then
                    stolentech[race] = true
                end
            end
        end
    end
    for race, val in stolentech do
        if not val then
            self:AddBuildRestriction(categories[race])
        end
    end
    ------------------------------------------------------------------------
    -- Human UI air/other switch
    ------------------------------------------------------------------------
    if aiBrain.BrainType == 'Human' then
        if self.airmode then
            self:AddBuildRestriction(categories.NAVAL)
            self:AddBuildRestriction(categories.MOBILESONAR)
            self:AddBuildRestriction(categories.LAND - categories.ENGINEER)
        else
            if self:GetCurrentLayer() == 'Land' then
                self:AddBuildRestriction(categories.NAVAL)
                self:AddBuildRestriction(categories.MOBILESONAR)
            elseif self:GetCurrentLayer() == 'Water' then
                self:AddBuildRestriction(categories.LAND - categories.ENGINEER)
            end
            self:AddBuildRestriction(categories.AIR)
        end
    ------------------------------------------------------------------------
    -- AI functional restrictions (allows easier AI control)
    ------------------------------------------------------------------------
    else
        if self:GetCurrentLayer() == 'Land' then
            self:AddBuildRestriction(categories.NAVAL)
            self:AddBuildRestriction(categories.MOBILESONAR)
        elseif self:GetCurrentLayer() == 'Water' then
            self:AddBuildRestriction(categories.LAND - categories.ENGINEER)
            self:AddBuildRestriction(categories.ues0401)
        end
    end
    self:RequestRefreshUI()
end
