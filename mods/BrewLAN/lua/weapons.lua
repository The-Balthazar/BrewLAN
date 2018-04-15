local WeaponsFile = import('/lua/sim/DefaultWeapons.lua')
local DefaultBeamWeapon = WeaponsFile.DefaultBeamWeapon
local BareBonesWeapon = WeaponsFile.BareBonesWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local BrewLANBeams = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/collisionbeams.lua')

ADFAlchemistPhasonLaser = Class(DefaultBeamWeapon) {
    BeamType = BrewLANBeams.AlchemistPhasonLaserCollisionBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = EffectTemplate.CMicrowaveLaserCharge01,
    FxUpackingChargeEffectScale = 1,

    PlayFxWeaponUnpackSequence = function( self )
        if not self.ContBeamOn then
            local army = self.unit:GetArmy()
            local bp = self:GetBlueprint()
            for k, v in self.FxUpackingChargeEffects do
                for ek, ev in bp.RackBones[self.CurrentRackSalvoNumber].MuzzleBones do
                    CreateAttachedEmitter(self.unit, ev, army, v):ScaleEmitter(self.FxUpackingChargeEffectScale)
                end
            end
            DefaultBeamWeapon.PlayFxWeaponUnpackSequence(self)
        end
    end,
}

--[[MaelstromDeathLaser = Class(DefaultBeamWeapon) {
    BeamType = BrewLANBeams.DeathLaserCollisionBeam,
    FxUpackingChargeEffects = {},
    FxUpackingChargeEffectScale = 1,
}]]--

EnergyStorageVariableDeathWeapon = Class(BareBonesWeapon) {
	FxDeath = EffectTemplate.ExplosionEffectsLrg02,

    OnCreate = function(self)
        BareBonesWeapon.OnCreate(self)
        self:SetWeaponEnabled(false)
    end,


    OnFire = function(self)
    end,

    Fire = function(self)
		local army = self.unit:GetArmy()
        for k, v in self.FxDeath do
            CreateEmitterAtBone(self.unit,-2,army,v)
        end
		local myBlueprint = self:GetBlueprint()
        DamageArea(self.unit, self.unit:GetPosition(), myBlueprint.DamageRadius + (self.DamageRadiusMod or 0), myBlueprint.Damage + (self.DamageMod or 0), myBlueprint.DamageType or 'Normal', myBlueprint.DamageFriendly or false)
    end,
}
