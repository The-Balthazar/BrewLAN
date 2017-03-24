--------------------------------------------------------------------------------
-- Summary  :  Cybran Cloakable Mobile Radar Stealth Script
--------------------------------------------------------------------------------
local CLandUnit = import('/lua/cybranunits.lua').CLandUnit
local EffectUtil = import('/lua/EffectUtilities.lua')

SRL0316 = Class(CLandUnit) {
    OnStopBeingBuilt = function(self,builder,layer)
        CLandUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetMaintenanceConsumptionActive()
        --Force update of the cloak effect if there is a cloak mesh. For FAF graphics
        if self:GetBlueprint().Display.CloakMeshBlueprint then
            self:ForkThread(
                function()
                    WaitTicks(1)
                    self:UpdateCloakEffect(true, 'Cloak')
                end
            )
        end
    end,

    IntelEffects = {
		{
			Bones = {
				'AttachPoint',
			},
			Offset = {
				0,
				0.3,
				0,
			},
			Scale = 0.2,
			Type = 'Jammer01',
		},
    },

    OnIntelEnabled = function(self)
        CLandUnit.OnIntelEnabled(self)
        if self.IntelEffects then
			self.IntelEffectsBag = {}
			self.CreateTerrainTypeEffects( self, self.IntelEffects, 'FXIdle',  self:GetCurrentLayer(), nil, self.IntelEffectsBag )
		end
    end,

    OnIntelDisabled = function(self)
        CLandUnit.OnIntelDisabled(self)
        EffectUtil.CleanupEffectBag(self,'IntelEffectsBag')
    end,
}

TypeClass = SRL0316
