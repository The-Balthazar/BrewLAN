#****************************************************************************
#**
#**  File     :  units/XRL0005/XRL0005_script.lua
#**
#**  Summary  :  Crab egg
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CConstructionEggUnit = import('/lua/cybranunits.lua').CConstructionEggUnit

ZELP001 = Class(CConstructionEggUnit) {

    OnStopBeingBuilt = function(self, builder, layer)
        local bp = self:GetBlueprint()
        local buildUnit = bp.Economy.BuildUnit
        
        local pos = self:GetPosition()
        
        local aiBrain = self:GetAIBrain()
	local Fatboy = CreateUnitHPR(buildUnit,aiBrain.Name,pos[1], pos[2], pos[3],0, 0, 0)
	local curHealth = self:GetHealth()
	Fatboy:SetHealth(Fatboy,curHealth)
        self:Destroy()
    end,
}

TypeClass = ZELP001