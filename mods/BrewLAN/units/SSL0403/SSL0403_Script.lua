#****************************************************************************
#**
#**  File     :  /cdimage/units/XSL0303/XSL0303_script.lua
#**  Author(s):  Dru Staltman, Aaron Lundquist
#**
#**  Summary  :  Seraphim Experimental Engineer
#**
#****************************************************************************

local SConstructionUnit = import('/lua/seraphimunits.lua').SConstructionUnit
local SLandUnit = import('/lua/seraphimunits.lua').SLandUnit
local WeaponsFile = import('/lua/seraphimweapons.lua')
local SDFAireauBolter = WeaponsFile.SDFAireauBolterWeapon
local SANUallCavitationTorpedo = WeaponsFile.SANUallCavitationTorpedo
local EffectUtil = import('/lua/EffectUtilities.lua')

SSL0403 = Class(SConstructionUnit) {
    Weapons = {
        Torpedo01 = Class(SANUallCavitationTorpedo) {},
        LeftTurret = Class(SDFAireauBolter) {},
        RightTurret = Class(SDFAireauBolter) {},
    },
}

TypeClass = SSL0403