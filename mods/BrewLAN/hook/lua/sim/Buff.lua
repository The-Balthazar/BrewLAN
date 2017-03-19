do
    local OldBuffAffectUnit = BuffAffectUnit
    function BuffAffectUnit(unit, buffName, instigator, afterRemove)
        local VersionIsFAF = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/legacy/VersionCheck.lua').VersionIsFAF()
        if buffName == 'DarknessOmniNerf' and not VersionIsFAF then
            local buffDef = Buffs[buffName]
            local buffAffects = buffDef.Affects
            if buffDef.OnBuffAffect and not afterRemove then
                buffDef:OnBuffAffect(unit, instigator)
            end
            for atype, vals in buffAffects do
                if atype == 'OmniRadius' then
                    local val = BuffCalculate(unit, buffName, 'OmniRadius', unit:GetBlueprint().Intel.OmniRadius or 0)
                    if not unit:IsIntelEnabled('Omni') then
                        unit:InitIntel(unit:GetArmy(),'Omni', val)
                        unit:EnableIntel('Omni')
                    else
                        unit:SetIntelRadius('Omni', val)
                        unit:EnableIntel('Omni')
                    end

                    if val <= 0 then
                        unit:DisableIntel('Omni')
                    end
                end
            end
        else
            OldBuffAffectUnit(unit, buffName, instigator, afterRemove)
        end
    end
end
