--------------------------------------------------------------------------------
-- Copyright : Sean 'Balthazar' Wheeldon
-- Energy storage with variable death weapon based on energy storage
--------------------------------------------------------------------------------
local EnergyStorageUnit = import('/lua/defaultunits.lua').EnergyStorageUnit
local EnergyStorageVariableDeathWeapon = import('../weapons.lua').EnergyStorageVariableDeathWeapon
local EffectTemplates = import('/lua/effecttemplates.lua')
local ExplosionEffectsSml01 = EffectTemplates.ExplosionEffectsSml01
local ExplosionEffectsMed01 = EffectTemplates.ExplosionEffectsMed01
local ExplosionEffectsLrg01 = EffectTemplates.ExplosionEffectsLrg01
local ExplosionEffectsLrg02 = EffectTemplates.ExplosionEffectsLrg02
local EffectTemplates = nil

VariableEnergyStorageUnit = Class(EnergyStorageUnit) {

    Weapons = {
        DeathWeapon = Class(EnergyStorageVariableDeathWeapon) {},
    },

    OnKilled = function(self, instigator, type, overkillRatio)
        local curEnergy = GetArmyBrain(self:GetArmy()):GetEconomyStoredRatio('ENERGY')
        local ReductionMult = 1 - curEnergy

        local weapon = self:GetWeaponByLabel('DeathWeapon')
        local weaponbp = weapon:GetBlueprint()
        local damage = weaponbp.Damage - 1000
        local radius = weaponbp.DamageRadius - 3

        weapon.DamageRadiusMod = - radius * ReductionMult
        weapon.DamageMod = - damage * ReductionMult

        if curEnergy < 0.2 then weapon.FxDeath = ExplosionEffectsSml01
        elseif curEnergy < 0.4 then weapon.FxDeath = ExplosionEffectsSml01
        elseif curEnergy < 0.6 then weapon.FxDeath = ExplosionEffectsMed01
        elseif curEnergy < 0.8 then weapon.FxDeath = ExplosionEffectsLrg01
        elseif curEnergy < 0.9 then weapon.FxDeath = ExplosionEffectsLrg01
        elseif curEnergy <= 1.0 then weapon.FxDeath = ExplosionEffectsLrg02
        end

        EnergyStorageUnit.OnKilled(self, instigator, type, overkillRatio)
    end,
}
