--------------------------------------------------------------------------------
-- Summary  :  Cybran Cloakable Radar Stealth Script
--------------------------------------------------------------------------------
local CRadarJammerUnit = import('/lua/cybranunits.lua').CRadarJammerUnit

SRB4313 = Class(CRadarJammerUnit) {
    OnStopBeingBuilt = function(self,builder,layer)
        CRadarJammerUnit.OnStopBeingBuilt(self,builder,layer)
        if not self.TowerSlider then
            self.TowerSlider = CreateSlider(self, 'Tower')
            self.Trash:Add(self.TowerSlider)
            self.TowerSlider:SetGoal(0, 0, -6.2)
            self.TowerSlider:SetSpeed(2)
        end
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

    OnIntelEnabled = function(self)
        CRadarJammerUnit.OnIntelEnabled(self)
        if self.TowerSlider then
            self.TowerSlider:SetGoal(0, 0, -6.2)
            self.TowerSlider:SetSpeed(2)
        end
    end,

    OnIntelDisabled = function(self)
        CRadarJammerUnit.OnIntelDisabled(self)
        self.TowerSlider:SetGoal(0, 0, 0)
        self.TowerSlider:SetSpeed(2)
    end,

    IntelEffects = {
		{
			Bones = {
				'Emitter',
			},
			Offset = {
				0,
				0,
				0,
			},
			Type = 'Jammer01',
		},
    },
}

TypeClass = SRB4313
