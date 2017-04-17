--------------------------------------------------------------------------------
--  Summary  :  Lazy Laser Eye Point Defence script
--------------------------------------------------------------------------------
local AStructureUnit = import('/lua/aeonunits.lua').AStructureUnit
local ADFPhasonLaser = import('/lua/aeonweapons.lua').ADFPhasonLaser
local utilities = import('/lua/utilities.lua')

SAB2306 = Class(AStructureUnit) {
    Weapons = {
        EyeWeapon = Class(ADFPhasonLaser) {},
    },

    OnKilled = function(self, instigator, type, overkillRatio)
        AStructureUnit.OnKilled(self, instigator, type, overkillRatio)
        local wep = self:GetWeaponByLabel('EyeWeapon')
        local bp = wep:GetBlueprint()
        if bp.Audio.BeamStop then
            wep:PlaySound(bp.Audio.BeamStop)
        end
        if bp.Audio.BeamLoop and wep.Beams[1].Beam then
            wep.Beams[1].Beam:SetAmbientSound(nil, nil)
        end
        for k, v in wep.Beams do
            v.Beam:Disable()
        end
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        AStructureUnit.OnStopBeingBuilt(self, builder, layer)
        local vectors = {'x','y','z'}
        for i, v in vectors do
            self.Trash:Add(CreateRotator(self, 'Head', v, nil, 0, 15, 10 + Random(0, 80) * (-1 + (2 * Random(0,1)))))
        end
    end,
}
TypeClass = SAB2306
