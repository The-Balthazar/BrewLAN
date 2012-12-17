#****************************************************************************
#**
#**  File     :  /mods/BrewLAN/units/BEA0401/BEA0401_script.lua
#**
#**  Summary  :  UEF Experimental Gunship script
#**
#**  Copyright © 2010 BrewLAN
#****************************************************************************

local TAirUnit = import('/lua/terranunits.lua').TAirUnit
local WeaponsFile = import('/lua/terranweapons.lua')
local TIFSmallYieldNuclearBombWeapon = WeaponsFile.TIFSmallYieldNuclearBombWeapon
local TAirToAirLinkedRailgun = WeaponsFile.TAirToAirLinkedRailgun
local TSAMLauncher = WeaponsFile.TSAMLauncher
local TDFHeavyPlasmaCannonWeapon = WeaponsFile.TDFHeavyPlasmaCannonWeapon
local TDFGaussCannonWeapon = WeaponsFile.TDFGaussCannonWeapon

local EffectUtil = import('/lua/EffectUtilities.lua')
local CreateUEFBuildSliceBeams = EffectUtil.CreateUEFBuildSliceBeams

SEA0401 = Class(TAirUnit) {
    Weapons = {
        GaussTurret01 = Class(TDFHeavyPlasmaCannonWeapon) {},
        GaussTurret02 = Class(TDFHeavyPlasmaCannonWeapon) {},
        GaussTurret03 = Class(TDFHeavyPlasmaCannonWeapon) {},
        GaussTurret04 = Class(TDFHeavyPlasmaCannonWeapon) {},
        GaussTurret05 = Class(TDFHeavyPlasmaCannonWeapon) {},
        GaussTurret06 = Class(TDFHeavyPlasmaCannonWeapon) {},
        FrontTurret01 = Class(TDFGaussCannonWeapon) {},
        FrontTurret02 = Class(TDFGaussCannonWeapon) {},
        LinkedRailGun1 = Class(TAirToAirLinkedRailgun) {},
        LinkedRailGun2 = Class(TAirToAirLinkedRailgun) {},
        MissileRack01 = Class(TSAMLauncher) {},
    },
    DestructionPartsChassisToss = {'BEA0401',},
    DestroyNoFallRandomChance = 1.1,
}

TypeClass = SEA0401
