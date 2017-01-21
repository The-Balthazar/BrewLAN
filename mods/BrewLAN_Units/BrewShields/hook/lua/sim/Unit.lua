do
    local oldUnit = Unit
    local ProjectedShield = import('/lua/shield.lua').ProjectedShield

    Unit = Class(oldUnit) {
        CreateProjectedShield = function(self, shieldSpec)
            local bp = self:GetBlueprint()
            local bpShield = shieldSpec
            if not shieldSpec then
                bpShield = bp.Defense.Shield
            end
            if bpShield then
                self:DestroyShield()
                self.MyShield = ProjectedShield {
                    Owner = self,
                    Mesh = bpShield.Mesh or '',
                    MeshZ = bpShield.MeshZ or '',
                    ImpactMesh = bpShield.ImpactMesh or '',
                    ImpactEffects = bpShield.ImpactEffects or '',
                    Size = bpShield.ShieldSize or 10,
                    ShieldMaxHealth = bpShield.ShieldMaxHealth or 250,
                    ShieldRechargeTime = bpShield.ShieldRechargeTime or 10,
                    ShieldEnergyDrainRechargeTime = bpShield.ShieldEnergyDrainRechargeTime or 10,
                    ShieldVerticalOffset = bpShield.ShieldVerticalOffset or -1,
                    ShieldRegenRate = bpShield.ShieldRegenRate or 1,
                    ShieldRegenStartTime = bpShield.ShieldRegenStartTime or 5,
                    PassOverkillDamage = bpShield.PassOverkillDamage or false,
                }
                self:SetFocusEntity(self.MyShield)
                self:EnableShield()
                self.Trash:Add(self.MyShield)
            end
        end,
    }
end
