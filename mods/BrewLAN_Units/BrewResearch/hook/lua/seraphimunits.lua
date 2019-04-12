local ResearchFactoryUnit = import('/lua/defaultunits.lua').ResearchFactoryUnit

SResearchFactoryUnit = Class(ResearchFactoryUnit) {

    StartBuildFx = function(self, unitBeingBuilt)
        local bp = self:GetBlueprint()
        local EffectUtil = import('/lua/effectutilities.lua')
		local BuildBones = bp.General.BuildBones.BuildEffectBones
        local thread = self:ForkThread( EffectUtil.CreateSeraphimFactoryBuildingEffects, unitBeingBuilt, BuildBones, 'Attachpoint', self.BuildEffectsBag )
        unitBeingBuilt.Trash:Add(thread)
        if ResearchFactoryUnit.StartBuildFx then
            ResearchFactoryUnit.StartBuildFx(self, unitBeingBuilt)
        end
    end,

}
