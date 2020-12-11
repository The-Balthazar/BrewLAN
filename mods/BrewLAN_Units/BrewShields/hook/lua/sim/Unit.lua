do
    local oldUnit = Unit
    local ProjectedShield = import('/lua/shield.lua').ProjectedShield

    Unit = Class(oldUnit) {
        CreateProjectedShield = function(self, shieldSpec)
            shieldSpec = shieldSpec or __blueprints.sab4401.Defense.TargetShield

            if shieldSpec then

                local bp = __blueprints[self.BpId] or self:GetBlueprint()
                local size = math.max(bp.Footprint.SizeX or 0, bp.Footprint.SizeZ or 0, bp.SizeX or 0, bp.SizeX or 0, bp.SizeY or 0, bp.SizeZ or 0, bp.Physics.MeshExtentsX or 0, bp.Physics.MeshExtentsY or 0, bp.Physics.MeshExtentsZ or 0) * 1.414

                self:DestroyShield()
                self.MyShield = ProjectedShield ({
                    Owner = self,
                    Mesh = shieldSpec.Mesh or '',
                    MeshZ = shieldSpec.MeshZ or '',
                    ImpactMesh = shieldSpec.ImpactMesh or '',
                    ImpactEffects = shieldSpec.ImpactEffects or '',
                    Size = size,
                    ShieldSize = size,
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
