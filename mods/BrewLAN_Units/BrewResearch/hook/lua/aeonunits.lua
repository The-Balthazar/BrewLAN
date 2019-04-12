local ResearchFactoryUnit = import('/lua/defaultunits.lua').ResearchFactoryUnit

AResearchFactoryUnit = Class(ResearchFactoryUnit) {

    StartBuildFx = function(self, unitBeingBuilt)
        local bp = self:GetBlueprint()
        local EffectUtil = import('/lua/effectutilities.lua')
        local thread = self:ForkThread( EffectUtil.CreateAeonFactoryBuildingEffects, unitBeingBuilt, bp.General.BuildBones.BuildEffectBones, 'Attachpoint', self.BuildEffectsBag )
        unitBeingBuilt.Trash:Add(thread)
        if ResearchFactoryUnit.StartBuildFx then
            ResearchFactoryUnit.StartBuildFx(self, unitBeingBuilt)
        end
    end,

}
