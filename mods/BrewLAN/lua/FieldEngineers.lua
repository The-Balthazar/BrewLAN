--------------------------------------------------------------------------------
-- Function for Support Commander field tech upgrade, and AI field tech cheating
--------------------------------------------------------------------------------
function SCUFieldUpgrade(SuperClass)
    return Class(SuperClass) {
        OnCreate = function(self)
            SuperClass.OnCreate(self)
            if self:GetAIBrain().BrainType == 'Human' then
                if categories.BUILTBYFIELD then
                    self:AddBuildRestriction(categories.BUILTBYFIELD)
                else
                    self:AddBuildRestriction(categories.BUILTBYTIER3FIELD)
                end
            end
        end,

        CreateEnhancement = function(self, enh)
            SuperClass.CreateEnhancement(self, enh)
            local bp = self:GetBlueprint().Enhancements[enh]
            local ParseEntityCategory = ParseEntityCategory
            if not bp then return end
            --Prevent ED4 ED5 duplication
            local restriction = categories.urb4206
            --Prevent duplication of advanced resouorce buildings.
            for i, v in {'a', 'e', 'r', 's'} do
                if categories['s'..v..'b1311'] then
                    restriction = restriction + ParseEntityCategory('u'..v..'b1301')
                end
                if categories['s'..v..'b1312'] then
                    restriction = restriction + ParseEntityCategory('u'..v..'b1302')
                end
                if categories['s'..v..'b1313'] then
                    restriction = restriction + ParseEntityCategory('u'..v..'b1303')
                end
            end
            if enh == 'Field' then
                if categories.BUILTBYFIELD then
                    self:RemoveBuildRestriction(categories.BUILTBYFIELD)
                else
                    self:RemoveBuildRestriction(categories.BUILTBYTIER3FIELD)
                end
                self:AddBuildRestriction(restriction)
            elseif enh == 'FieldRemove' then
                if categories.BUILTBYFIELD then
                    self:AddBuildRestriction(categories.BUILTBYFIELD)
                else
                    self:AddBuildRestriction(categories.BUILTBYTIER3FIELD)
                end
                self:RemoveBuildRestriction(restriction)
            end
        end,
    }
end
--------------------------------------------------------------------------------
-- Function for AI field tech cheating with regular engineers
--------------------------------------------------------------------------------
function RegularAIEngineer(SuperClass)
    return Class(SuperClass) {
        OnCreate = function(self)
            SuperClass.OnCreate(self)
            if self:GetAIBrain().BrainType == 'Human' then
                self:AddBuildRestriction(categories.BUILTBYTIER3FIELD)
                if categories.BUILTBYFIELD then
                    self:AddBuildRestriction(categories.BUILTBYFIELD)
                end
            end
        end,
    }
end
--------------------------------------------------------------------------------
-- Used by engineering boats to assist things when idle
--------------------------------------------------------------------------------
function AssistThread(self)
    while true do
        if self:IsIdleState() then
            --Insert some kind of table sort for most damaged here
            local units = self:GetAIBrain():GetUnitsAroundPoint(categories.SELECTABLE, self:GetPosition(), 30, 'Ally' )
            for i, v in units do
                if v:GetHealthPercent() ~= 1 then
                    IssueRepair({self}, v)
                end
            end
        end
        WaitTicks(30)
    end
end
