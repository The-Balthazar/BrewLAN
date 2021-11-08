--------------------------------------------------------------------------------
--  UEF Wall: With cordinal scripting
--------------------------------------------------------------------------------
local BrewLANSelfDefendingCardinalWallUnit = import('/lua/defaultunits.lua').BrewLANSelfDefendingCardinalWallUnit

SEB5310 = Class(BrewLANSelfDefendingCardinalWallUnit) {
    BuildAttachBone = 'Build_Node',

    OnStartBuild = function(self, unitBeingBuilt, order )
        BrewLANSelfDefendingCardinalWallUnit.OnStartBuild(self, unitBeingBuilt, order )

        self:ForkThread(
            function()
                WaitSeconds(0.2)
                unitBeingBuilt.Leg = import('/lua/sim/Entity.lua').Entity({Owner = self,})
                Warp(unitBeingBuilt.Leg,unitBeingBuilt:GetPosition())
                unitBeingBuilt.Leg:AttachBoneTo( -1, self, 'Build_Node' )
                unitBeingBuilt.Leg:SetMesh(import( '/lua/game.lua' ).BrewLANPath .. '/effects/entities/UEF_SIZE4_Floatation/UEF_SIZE4_Floatation_mesh')
                unitBeingBuilt.Leg:SetDrawScale(0.083)
                unitBeingBuilt.Leg:SetVizToAllies('Intel')
                unitBeingBuilt.Leg:SetVizToNeutrals('Intel')
                unitBeingBuilt.Leg:SetVizToEnemies('Intel')
                unitBeingBuilt.Trash:Add(unitBeingBuilt.Leg)
            end
        )
    end,
}

TypeClass = SEB5310
