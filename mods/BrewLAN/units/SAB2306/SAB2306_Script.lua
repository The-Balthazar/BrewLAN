#****************************************************************************
#**
#**  File     :  /cdimage/units/UAL0401/UAL0401_script.lua
#**  Author(s):  John Comes, Gordon Duclos
#**
#**  Summary  :  Aeon Galactic Colossus Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
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
}
TypeClass = SAB2306