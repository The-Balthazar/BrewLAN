local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit

SEB5381 = Class(TStructureUnit) {
    --When we're adjacent, try to all all the possible bonuses.
    OnAdjacentTo = function(self, adjacentUnit, triggerUnit)
        if self:IsBeingBuilt() then return end
        if adjacentUnit:IsBeingBuilt() then return end
        self:CalculateWeaponDamageBuff(adjacentUnit)
        TStructureUnit.OnAdjacentTo(self, adjacentUnit, triggerUnit)
    end,

    --When we're not adjacent, try to remove all the possible bonuses.
    OnNotAdjacentTo = function(self, adjacentUnit)
        self:CalculateWeaponDamageBuff(adjacentUnit, true)
        TStructureUnit.OnNotAdjacentTo(self, adjacentUnit)
    end,

    CalculateWeaponDamageBuff = function(self, adjacentUnit, remove)
        for i, v in {4,8,12,16,20} do
            if EntityCategoryContains(categories['SIZE' .. v], adjacentUnit) then
                for i = 1, adjacentUnit:GetWeaponCount() do
                    local wep = adjacentUnit:GetWeapon(i)
                    local wepbp = wep:GetBlueprint()
                    local boost = 0.5 / v
                    if wepbp.BeamCollisionDelay then
                        --DamageModifiers on a beam weapon is an array, which has all its values multiplied together with Damgage to make DamageAmount
                        if not wep.DamageModifiers then wep.DamageModifiers = {} end
                        if not wep.DamageModifiers.BoostNode then wep.DamageModifiers.BoostNode = 1 end
                        if remove then
                            wep.DamageModifiers.BoostNode = wep.DamageModifiers.BoostNode - boost
                        else
                            wep.DamageModifiers.BoostNode = wep.DamageModifiers.BoostNode + boost
                        end
                    else
                        --DamageMod on projectile weapons is added as-is to Damage to get DamageAmount
                        if not wep.DamageMod then wep.DamageMod = 0 end
                        if wepbp.Damage then
                            if remove then
                                wep.DamageMod = wep.DamageMod - (wepbp.Damage * boost )
                            else
                                wep.DamageMod = wep.DamageMod + (wepbp.Damage * boost )
                            end
                        end
                    end
                end
                break
            end
        end
    end,
}

TypeClass = SEB5381
