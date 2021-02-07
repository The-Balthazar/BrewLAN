--------------------------------------------------------------------------------
--  Summary  : Seraphim T2 Transport Script
--------------------------------------------------------------------------------
local SAirUnit = import('/lua/seraphimunits.lua').SAirUnit
local explosion = import('/lua/defaultexplosions.lua')
local util = import('/lua/utilities.lua')
local SeraphimWeapons = import('/lua/seraphimweapons.lua')
local SAALosaareAutoCannonWeaponAirUnit = SeraphimWeapons.SAALosaareAutoCannonWeaponAirUnit
local SDFHeavyPhasicAutoGunWeapon = SeraphimWeapons.SDFHeavyPhasicAutoGunWeapon

local BrewLANPath = import('/lua/game.lua').BrewLANPath
local VersionIsFAF = import(BrewLANPath .. "/lua/legacy/versioncheck.lua").VersionIsFAF()
if VersionIsFAF then
    SAirUnit = import('/lua/defaultunits.lua').AirTransport
end

SSA0306 = Class(SAirUnit) {

    AirDestructionEffectBones = { 'BSA0306','Left_Attachpoint08','Right_Attachpoint02'},

    Weapons = {
        AutoGun = Class(SDFHeavyPhasicAutoGunWeapon) {},
        AA = Class(SAALosaareAutoCannonWeaponAirUnit) {},
    },

    -- Override air destruction effects so we can do something custom here
    CreateUnitAirDestructionEffects = function( self, scale )
        self:ForkThread(self.AirDestructionEffectsThread, self )
    end,

    AirDestructionEffectsThread = function( self )
        local numExplosions = math.floor( table.getn( self.AirDestructionEffectBones ) * 0.5 )
        for i = 0, numExplosions do
            explosion.CreateDefaultHitExplosionAtBone( self, self.AirDestructionEffectBones[util.GetRandomInt( 1, numExplosions )], 0.5 )
            WaitSeconds( util.GetRandomFloat( 0.2, 0.9 ))
        end
    end,
}

TypeClass = SSA0306
