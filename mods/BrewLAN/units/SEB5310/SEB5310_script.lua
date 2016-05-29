#****************************************************************************
#** 
#**  UEF Wall: With cordinal scripting
#** 
#****************************************************************************
local StackingBuilderUnit = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/defaultunits.lua').StackingBuilderUnit
local CardinalWallUnit = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/walls.lua').CardinalWallUnit
StackingBuilderUnit = CardinalWallUnit(StackingBuilderUnit) 

SEB5310 = Class(StackingBuilderUnit) {
    OnStartBuild = function(self, unitBeingBuilt, order )
        StackingBuilderUnit.OnStartBuild(self, unitBeingBuilt, order )
        
        self:ForkThread(
            function()
                WaitSeconds(0.2)
                unitBeingBuilt.Leg = import('/lua/sim/Entity.lua').Entity({Owner = self,})
                Warp(unitBeingBuilt.Leg,unitBeingBuilt:GetPosition())
                unitBeingBuilt.Leg:AttachBoneTo( -1, self, 'Build_Node' )
                unitBeingBuilt.Leg:SetMesh(import( '/lua/game.lua' ).BrewLANPath() .. '/effects/entities/UEF_SIZE4_Floatation/UEF_SIZE4_Floatation_mesh')
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
