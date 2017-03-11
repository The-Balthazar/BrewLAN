do
    local OldBuffAffectUnit = BuffAffectUnit
    function BuffAffectUnit(unit, buffName, instigator, afterRemove)
        if string.sub(buffName,1,32) == 'T3WeaponBoosterAccuracyBonusSize' then
            local buffDef = Buffs[buffName]
            local buffAffects = buffDef.Affects
            if buffDef.OnBuffAffect and not afterRemove then
                buffDef:OnBuffAffect(unit, instigator)
            end
            for atype, vals in buffAffects do
                if atype == 'FiringRandomness' then
                    for i = 1, unit:GetWeaponCount() do
                        local wep = unit:GetWeapon(i)
                        local wepbp = wep:GetBlueprint()
                        local wepfr = wepbp.FiringRandomness
                        --LOG(wepfr)
                        local val = BuffCalculate(unit, buffName, 'FiringRandomness', 1)
                        --LOG(val)
                        wep:SetFiringRandomness( wepfr * val )
                        --LOG('*BUFF: FiringRandomness = ' ..  wepfr * val )
                    end
                end
            end
        else
            OldBuffAffectUnit(unit, buffName, instigator, afterRemove)
        end
    end
end
