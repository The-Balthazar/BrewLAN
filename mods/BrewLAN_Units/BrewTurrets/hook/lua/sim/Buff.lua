local BLCCBuffTypes = {
    FiringRandomness = function(unit, buffName)
        for i = 1, unit:GetWeaponCount() do
            local wep = unit:GetWeapon(i)
            local wepfr = wep:GetBlueprint().FiringRandomness
            local val = BuffCalculate(unit, buffName, 'FiringRandomness', 1)
            wep:SetFiringRandomness( wepfr * val )
        end
    end,

    ShieldRegeneration = function(unit, buffName)
        if unit.MyShield then
            local val = BuffCalculate(unit, buffName, 'ShieldRegeneration', 1)
            local regenrate = unit:GetBlueprint().Defense.Shield.ShieldRegenRate or 1

            unit.MyShield:SetShieldRegenRate(val * regenrate)
        end
    end,
}

do
    local OldBuffAffectUnit = BuffAffectUnit

    function BuffAffectUnit(unit, buffName, instigator, afterRemove)

        local buffDef = Buffs[buffName]
        local buffAffects = buffDef.Affects

        local fType, fVals = next(buffAffects)
        local sType, sVals = next(buffAffects, fType)

        if not fType then
            return
        end

        if sType or not BLCCBuffTypes[fType] then
            return OldBuffAffectUnit(unit, buffName, instigator, afterRemove)
        end

        -- New stuff
        if buffDef.OnBuffAffect and not afterRemove then
            buffDef:OnBuffAffect(unit, instigator)
        end

        BLCCBuffTypes[fType](unit, buffName)
    end
end
