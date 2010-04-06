#****************************************************************************
#**
#**  File     :  /mods/BrewLAN/units/BEA0401/BEA0401_script.lua
#**
#**  Summary  :  UEF Experimental Gunship script
#**
#**  Copyright © 2010 BrewLAN
#****************************************************************************

local TAirUnit = import('/lua/terranunits.lua').TAirUnit
local TIFSmallYieldNuclearBombWeapon = import('/lua/terranweapons.lua').TIFSmallYieldNuclearBombWeapon
local TAirToAirLinkedRailgun = import('/lua/terranweapons.lua').TAirToAirLinkedRailgun

local EffectUtil = import('/lua/EffectUtilities.lua')
local CreateUEFBuildSliceBeams = EffectUtil.CreateUEFBuildSliceBeams

BEA0401 = Class(TAirUnit) {
    Weapons = {
        Bomb = Class(TIFSmallYieldNuclearBombWeapon) {},
        LinkedRailGun1 = Class(TAirToAirLinkedRailgun) {},
        LinkedRailGun2 = Class(TAirToAirLinkedRailgun) {},
    },
    DestructionPartsChassisToss = {'BEA0401',},
    DestroyNoFallRandomChance = 1.1,
}

TypeClass = BEA0401
