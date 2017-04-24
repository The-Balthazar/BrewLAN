--------------------------------------------------------------------------------
-- Function for Support Commander field tech upgrade, and AI field tech cheating
--------------------------------------------------------------------------------
function SCUFieldUpgrade(SuperClass)
    return Class(SuperClass) {
        OnCreate = function(self)
            SuperClass.OnCreate(self)
            if self:GetAIBrain().BrainType == 'Human' then
                self:AddBuildRestriction(categories.BUILTBYTIER3FIELD)
            end
        end,

        CreateEnhancement = function(self, enh)
            SuperClass.CreateEnhancement(self, enh)
            local bp = self:GetBlueprint().Enhancements[enh]
            if not bp then return end
            --Field
            local restriction = (categories.ECONOMIC * categories.TECH3) - categories.BUILTBYTIER3FIELD - categories.MASSSTORAGE - categories.ENERGYSTORAGE - categories.HYDROCARBON
            if enh == 'Field' then
                self:RemoveBuildRestriction(categories.BUILTBYTIER3FIELD)
                self:AddBuildRestriction(restriction)
                self:AddBuildRestriction(categories.urb4206)
            elseif enh == 'FieldRemove' then
                self:AddBuildRestriction(categories.BUILTBYTIER3FIELD)
                self:RemoveBuildRestriction(restriction)
                self:RemoveBuildRestriction(categories.urb4206)
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
            end
        end,
    }
end
--------------------------------------------------------------------------------
-- Function for AI field tech cheating with regular engineers
--------------------------------------------------------------------------------
function AssistThread(self)
    while true do
        if self:IsIdleState() then
            --Insert some kind of table sort for most damaged here
            local units = self:GetAIBrain():GetUnitsAroundPoint(categories.SELECTABLE, self:GetPosition(), 30, 'Ally' )
            for i, v in units do
                if v:GetHealthPercent() != 1 then
                    IssueRepair({self}, v)
                end
            end
        end
        WaitTicks(30)
    end
end
