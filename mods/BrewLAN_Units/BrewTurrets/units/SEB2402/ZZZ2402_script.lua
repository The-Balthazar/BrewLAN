--------------------------------------------------------------------------------
--  Maelstrom core colision model
--------------------------------------------------------------------------------
local StructureUnit = import('/lua/defaultunits.lua').StructureUnit

ZZZ2402 = Class(StructureUnit) {
    OnDamage = function(self, instigator, amount, vector, damageType)
        if self.Parent then
            self.Parent:OnDamage(instigator, amount, vector, damageType)
        end
    end,
}

TypeClass = ZZZ2402
