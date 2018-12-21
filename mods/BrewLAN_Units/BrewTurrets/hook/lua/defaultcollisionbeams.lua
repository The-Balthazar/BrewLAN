DeathLaserCollisionBeam = Class(OrbitalDeathLaserCollisionBeam) {
    FxBeam = {'/mods/BrewLAN_Units/BrewTurrets/effects/emitters/brewlan_maelstrom_death_laser_beam_01_emit.bp'},
    FxBeamStartPoint = {'/effects/emitters/uef_orbital_death_laser_muzzle_01_emit.bp'},
}

DisarmBeam = Class(UltraChromaticBeamGeneratorCollisionBeam) {
    OnImpact = function(self, impactType, targetEntity)
        if impactType == 'Unit' and IsUnit(targetEntity) then
            local bp = targetEntity:GetBlueprint()
            local weps = {}
            for i, v in bp.Weapon do
                if v.RackBones and v.WeaponCategory ~= 'Death' then -- and targetEntity:GetWeaponByLabel(v.Label):IsEnabled() then
                    table.insert(weps, i)
                end
            end
            local randwep = bp.Weapon[math.random(1,table.getn(weps))]
            targetEntity:SetWeaponEnabledByLabel(randwep.Label, false)
            local bones = {
                randwep.TurretBoneMuzzle,
                randwep.TurretBonePitch,
                randwep.TurretBoneYaw,
            }
            if randwep.Turreted then
                for i, v in bones do
                    if targetEntity:IsValidBone(v) then
                        targetEntity:HideBone(v, true)
                    end
                end
            end
        end
        UltraChromaticBeamGeneratorCollisionBeam.OnImpact(self, impactType, targetEntity)
    end,
}
