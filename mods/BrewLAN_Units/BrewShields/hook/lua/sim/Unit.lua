do
    local oldUnit = Unit
    local ProjectedShield = import('/lua/shield.lua').ProjectedShield

    Unit = Class(oldUnit) {

        OnPreCreate = function(self)
            oldUnit.OnPreCreate(self)
            self.EntityId = self:GetEntityId()
        end,

        CreateProjectedShield = function(self, shieldSpec)
            shieldSpec = shieldSpec or __blueprints.sab4401.Defense.Shield

            if shieldSpec then

                local bp = self.bp or __blueprints[self.BpId] or self:GetBlueprint()

                self.MyShield = ProjectedShield ({
                    Owner = self,
                    Mesh = shieldSpec.Mesh or '',
                    MeshZ = shieldSpec.MeshZ or '',
                    ImpactMesh = shieldSpec.ImpactMesh or '',
                    ImpactEffects = shieldSpec.ImpactEffects or '',
                    Size = bp.Defense.Shield.ProjShieldSize,
                    ShieldSize = bp.Defense.Shield.ProjShieldSize,
                    ShieldMaxHealth = shieldSpec.ShieldMaxHealth or 250,
                    ShieldRechargeTime = shieldSpec.ShieldRechargeTime or 10,
                    ShieldEnergyDrainRechargeTime = shieldSpec.ShieldEnergyDrainRechargeTime or 10,
                    ShieldVerticalOffset = bp.CollisionOffsetY or 0,
                    ShieldRegenRate = shieldSpec.ShieldRegenRate or 1,
                    ShieldRegenStartTime = shieldSpec.ShieldRegenStartTime or 5,
                    PassOverkillDamage = shieldSpec.PassOverkillDamage or false,
                }, self)
                self:SetFocusEntity(self.MyShield)
                self:EnableShield()
                self.Trash:Add(self.MyShield)
            end
        end,
    }
end
