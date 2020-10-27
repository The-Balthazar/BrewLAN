do
    local OldFactoryBuilderManager = FactoryBuilderManager

    FactoryBuilderManager = Class(OldFactoryBuilderManager) {
        AddFactory = function(self,unit)
            if not EntityCategoryContains( categories.RESEARCHCENTRE, unit ) then
                OldFactoryBuilderManager.AddFactory(self,unit)
            end
        end,
    }
end
