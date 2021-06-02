local AStructureUnit = import('/lua/aeonunits.lua').AStructureUnit
local AANChronoTorpedoWeapon = import('/lua/aeonweapons.lua').AANChronoTorpedoWeapon

SAB2308 = Class(AStructureUnit) {
    Weapons = {
        Turret01 = Class(AANChronoTorpedoWeapon) {},
    },

	OnCreate = function(self)
		AStructureUnit.OnCreate(self)
        for i, v in {0.85, 0.45} do
            self.DomeEntity = import('/lua/sim/Entity.lua').Entity({Owner = self,})
            self.DomeEntity:AttachBoneTo( -1, self, 'UAB2205' )
            self.DomeEntity:SetMesh('/effects/Entities/UAB2205_Dome/UAB2205_Dome_mesh')
            self.DomeEntity:SetDrawScale(v)
            self.DomeEntity:SetVizToAllies('Intel')
            self.DomeEntity:SetVizToNeutrals('Intel')
            self.DomeEntity:SetVizToEnemies('Intel')
            self.Trash:Add(self.DomeEntity)
        end
	end,
}

TypeClass = SAB2308
