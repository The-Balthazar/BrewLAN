local SAirStagingPlatformUnit = import('/lua/seraphimunits.lua').SAirStagingPlatformUnit
local EffectTemplates = import('/lua/EffectTemplates.lua')
local SeraphimAirStagePlat02 = EffectTemplates.SeraphimAirStagePlat02
local SeraphimAirStagePlat01 = EffectTemplates.SeraphimAirStagePlat01

SSB5104 = Class(SAirStagingPlatformUnit) {
    OnStopBeingBuilt = function(self,builder,layer)
        for k, v in SeraphimAirStagePlat02 do
            CreateAttachedEmitter(self, 0, self:GetArmy(), v):ScaleEmitter(0.3)
        end

        for k, v in SeraphimAirStagePlat01 do
            CreateAttachedEmitter(self, 'Pod01', self:GetArmy(), v):ScaleEmitter(0.8)
        end

        SAirStagingPlatformUnit.OnStopBeingBuilt(self, builder, layer)
    end,
}

TypeClass = SSB5104
