#
# UEF Anti-Matter Shells
#
local TArtilleryAntiMatterProjectile = import('/lua/terranprojectiles.lua').TArtilleryAntiMatterProjectile02
local Util = import('/lua/utilities.lua')
TIFDropPodArtilleryMechMarine = Class(TArtilleryAntiMatterProjectile) {

    FxLandHitScale = 0.2,
    FxUnitHitScale = 0.2,
    FxSplatScale = 1,

    OnImpact = function(self, TargetType, TargetEntity)
        TArtilleryAntiMatterProjectile.OnImpact(self, TargetType, TargetEntity)

        local pos = self:GetPosition()
	local AssaultBot = CreateUnitHPR('uel0106',self:GetArmy(),pos[1], pos[2], pos[3],0, 0, 0)

	#local curHealth = self:GetHealth()
	#AssaultBot:SetHealth(AssaultBot,curHealth)

        self:Destroy()
    end,
}

TypeClass = TIFDropPodArtilleryMechMarine