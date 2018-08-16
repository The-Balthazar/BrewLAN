local BeamsFile = import('/lua/defaultcollisionbeams.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')

MaelstromDeathLaser = Class(DefaultBeamWeapon) {
    BeamType = BeamsFile.DeathLaserCollisionBeam,
    FxUpackingChargeEffects = {},
    FxUpackingChargeEffectScale = 1,
}

DisarmBeamWeapon = Class(DefaultBeamWeapon) {
    BeamType = BeamsFile.DisarmBeam,
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
