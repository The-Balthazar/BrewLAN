
FootprintDummyUnit = Class(StructureUnit) {

    OnAdjacentTo = function(self, AdjUnit, TriggerUnit)
        if not self.AdjacentData then self.AdjacentData = {} end

        table.insert(self.AdjacentData, AdjUnit)

        StructureUnit.OnAdjacentTo(self, AdjUnit, TriggerUnit)
    end,

    OnNotAdjacentTo = function(self, AdjUnit)
        
        self.Parent.OnNotAdjacentTo(self.Parent, AdjUnit)
        AdjUnit:OnNotAdjacentTo(self.Parent)
        self.ForceDestroyAdjacentEffects({self.Parent, AdjUnit})

        StructureUnit.OnNotAdjacentTo(self, AdjUnit)
    end,
}
