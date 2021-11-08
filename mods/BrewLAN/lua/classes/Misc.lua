--------------------------------------------------------------------------------
-- Copyright : Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
local WalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local StructureUnit = import('/lua/defaultunits.lua').StructureUnit

-- Makes the walk animation reverse if it goes backwards
DirectionalWalkingLandUnit = Class(WalkingLandUnit) {
    OnMotionHorzEventChange = function( self, new, old )
        WalkingLandUnit.OnMotionHorzEventChange(self, new, old)
        if ( old == 'Stopped' ) and self.Animator then
            self.Animator:SetDirectionalAnim(true)
        end
    end,
}

-- Used primarily by SAB5401, but also others like mines,
-- for tracking adjacency and making and breaking path blocking.
FootprintDummyUnit = Class(StructureUnit) {
    OnAdjacentTo = function(self, AdjUnit, TriggerUnit)
        if not self.AdjacentData then self.AdjacentData = {} end
        table.insert(self.AdjacentData, AdjUnit)
        StructureUnit.OnAdjacentTo(self, AdjUnit, TriggerUnit)
    end,

    OnNotAdjacentTo = function(self, AdjUnit)
        if self.Parent then
            self.Parent.OnNotAdjacentTo(self.Parent, AdjUnit)
            AdjUnit:OnNotAdjacentTo(self.Parent)
            self.ForceDestroyAdjacentEffects({self.Parent, AdjUnit})
        end
        StructureUnit.OnNotAdjacentTo(self, AdjUnit)
    end,
}
