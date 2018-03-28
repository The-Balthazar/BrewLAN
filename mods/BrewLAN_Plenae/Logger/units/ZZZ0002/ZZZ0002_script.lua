local AShieldStructureUnit = import('/lua/aeonunits.lua').AShieldStructureUnit

ZZZ0002 = Class(AShieldStructureUnit) {
    OnCreate = function(self)
        AShieldStructureUnit.OnCreate(self)
        self.DomeEntity = import('/lua/sim/Entity.lua').Entity({Owner = self,})
        self.DomeEntity:AttachBoneTo( -1, self, 0 )
        self.DomeEntity:SetMesh('/mods/brewlan_plenae/logger/units/zzz0002/zzz0002_domes_mesh')
        self.DomeEntity:SetDrawScale(self:GetBlueprint().Display.UniformScale)
        self.DomeEntity:SetVizToAllies('Intel')
        self.DomeEntity:SetVizToNeutrals('Intel')
        self.DomeEntity:SetVizToEnemies('Intel')
        self.Trash:Add(self.DomeEntity)
    end,
}

TypeClass = ZZZ0002
