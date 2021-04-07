--[[local ConstructionStructureUnit = DefaultUnitsFile.ConstructionStructureUnit

CConstructionStructureUnit = Class(ConstructionStructureUnit) {
    CreateBuildEffects = function(self, unitBeingBuilt, order)
        local buildbots = EffectUtil.SpawnBuildBots(self, unitBeingBuilt, table.getn(self.BuildEffectBones), self.BuildEffectsBag)
        if buildbots then
            EffectUtil.CreateCybranEngineerBuildEffects(self, self.BuildEffectBones, buildbots, self.BuildEffectsBag)
        else
            EffectUtil.CreateCybranBuildBeams(self, unitBeingBuilt, self.BuildEffectBones, self.BuildEffectsBag)
        end
    end,
}]]

local DirectionalWalkingLandUnit = DefaultUnitsFile.DirectionalWalkingLandUnit

CDirectionalWalkingLandUnit = Class(DirectionalWalkingLandUnit) {}
