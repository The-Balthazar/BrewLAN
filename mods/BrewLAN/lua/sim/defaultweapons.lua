--------------------------------------------------------------------------------
-- From FaF, because they deleted TIFCommanderDeathWeapon, and broke everything.
--------------------------------------------------------------------------------
local NukeDamage = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/sim/NukeDamage.lua').NukeAOE
local BareBonesWeapon = import('/lua/sim/DefaultWeapons.lua').BareBonesWeapon

DeathNukeWeapon = Class(BareBonesWeapon) {
    OnFire = function(self)
        return self.Fire(self)
    end,

    Fire = function(self)
        local bp = self:GetBlueprint()
        local proj = self.unit:CreateProjectile(bp.ProjectileId, 0, 0, 0, nil, nil, nil):SetCollision(false)
        proj:ForkThread(proj.EffectThread)
        
        -- Play the explosion sound
        local projBp = proj:GetBlueprint()
        if projBp.Audio.NukeExplosion then
            self:PlaySound(projBp.Audio.NukeExplosion)
        end
        
        proj.InnerRing = NukeDamage()
        proj.InnerRing:OnCreate(bp.NukeInnerRingDamage, bp.NukeInnerRingRadius, bp.NukeInnerRingTicks, bp.NukeInnerRingTotalTime)
        proj.OuterRing = NukeDamage()
        proj.OuterRing:OnCreate(bp.NukeOuterRingDamage, bp.NukeOuterRingRadius, bp.NukeOuterRingTicks, bp.NukeOuterRingTotalTime)
        
        local firer = self.unit
        local pos = proj:GetPosition()
        proj.InnerRing:DoNukeDamage(firer, pos)
        proj.OuterRing:DoNukeDamage(firer, pos)
    end,
}
