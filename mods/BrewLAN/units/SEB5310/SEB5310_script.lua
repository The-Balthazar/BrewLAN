#****************************************************************************
#** 
#**  Cybran Wall: With cordinal scripting
#** 
#****************************************************************************

local CardinalWallScript = import('/mods/brewlan/lua/defaultunits.lua').CardinalWallScript

SEB5310 = Class(CardinalWallScript) {
    OnStartBuild = function(self, unitBeingBuilt, order )
        CardinalWallScript.OnStartBuild(self, unitBeingBuilt, order )
        
        self:ForkThread(
            function()
                WaitSeconds(0.2)
                unitBeingBuilt.Leg = import('/lua/sim/Entity.lua').Entity({Owner = self,})
                Warp(unitBeingBuilt.Leg,unitBeingBuilt:GetPosition())
                unitBeingBuilt.Leg:AttachBoneTo( -1, self, 'Build_Node' )
                unitBeingBuilt.Leg:SetMesh('/mods/BrewLAN/effects/entities/UEF_SIZE4_Floatation/UEF_SIZE4_Floatation_mesh')
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