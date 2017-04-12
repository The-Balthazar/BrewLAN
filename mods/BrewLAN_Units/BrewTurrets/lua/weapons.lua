local DefaultBeamWeapon = import('/lua/sim/DefaultWeapons.lua').DefaultBeamWeapon
local CollisionBeamFile = import('/lua/defaultcollisionbeams.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')

DisarmBeam = Class(CollisionBeamFile.UltraChromaticBeamGeneratorCollisionBeam) {

    OnImpact = function(self, impactType, targetEntity)
        if impactType == 'Unit' and IsUnit(targetEntity) then
            local bp = targetEntity:GetBlueprint()
            local weps = {}
            for i, v in bp.Weapon do
                if v.RackBones and v.WeaponCategory != 'Death' then -- and targetEntity:GetWeaponByLabel(v.Label):IsEnabled() then
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
            for i, v in bones do
                if targetEntity:IsValidBone(v) then
                    targetEntity:HideBone(v, true)
                end
            end
        end
        CollisionBeamFile.UltraChromaticBeamGeneratorCollisionBeam.OnImpact(self, impactType, targetEntity)
    end,
}

DisarmBeamWeapon = Class(DefaultBeamWeapon) {
    BeamType = DisarmBeam,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = EffectTemplate.SChargeUltraChromaticBeamGenerator,
    FxUpackingChargeEffectScale = 1,

    --[[PlayFxWeaponUnpackSequence = function( self )
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
    end,]]--

}
