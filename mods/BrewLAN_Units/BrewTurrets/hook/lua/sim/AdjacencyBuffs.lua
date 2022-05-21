
T3WeaponBoosterAccuracyAdjacencyBuffs = {}
T3WeaponBoosterDamageAdjacencyBuffs = {}
T3ShieldBoosterRegenAdjacencyBuffs = {}
T3HealthBoosterRegenAdjacencyBuffs = {'T3HealthBoosterRegenBonus'}
T3EngineeringBoosterAdjacencyBuffs = {'T3EngineeringBoosterBonus'}

BuffBlueprint {
    Name = 'T3EngineeringBoosterBonus',
    DisplayName = 'T3EngineeringBoosterBonus',
    BuffType = 'ENGINEERBOOSTERNODE',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE',
    BuffCheckFunction = AdjBuffFuncs.EnergyBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.DefaultBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        BuildRate = {
            Add = 5,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T3HealthBoosterRegenBonus',
    DisplayName = 'T3HealthBoosterRegenBonus',
    BuffType = 'REGENBOOSTERNODE',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE',
    BuffCheckFunction = function() return true end,
    OnBuffAffect = AdjBuffFuncs.DefaultBuffAffect,
    OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
    Affects = {
        Regen = {
            Add = 1,
            Mult = 1.0,
        },
    },
}

do
    local AccuracyMult = 5
    local EnergyMaintMult = 40
    local ShieldRegenMult = 10

    local hasShield = function(buff, unit)
        return unit:GetBlueprint().Defense.Shield
    end

    local buffs = {
        T3WeaponBoosterAccuracyBonus = {
            SizeData = {
                [4] = -0.025 * AccuracyMult,
                [8] = -0.0125 * AccuracyMult,
                [12] = -0.008333 * AccuracyMult,
                [16] = -0.00625 * AccuracyMult,
                [20] = -0.005 * AccuracyMult,
            },
            BuffType = 'ACCURACYBONUS',
            Affects = 'FiringRandomness',
            BuffCheckFunction = AdjBuffFuncs.RateOfFireBuffCheck,
            OnBuffAffect = AdjBuffFuncs.RateOfFireBuffAffect,
            OnBuffRemove = AdjBuffFuncs.RateOfFireBuffRemove,
            IncludeIn = {
                T3WeaponBoosterAccuracyAdjacencyBuffs,
            },
        },
        T3WeaponBoosterRateOfFireTradeOff = {
            SizeData = {
                [4] = 0.025 * AccuracyMult,
                [8] = 0.0125 * AccuracyMult,
                [12] = 0.008333 * AccuracyMult,
                [16] = 0.00625 * AccuracyMult,
                [20] = 0.005 * AccuracyMult,
            },
            BuffType = 'RATEOFFIREADJACENCY',
            Affects = 'RateOfFire',
            BuffCheckFunction = AdjBuffFuncs.RateOfFireBuffCheck,
            OnBuffAffect = AdjBuffFuncs.RateOfFireBuffAffect,
            OnBuffRemove = AdjBuffFuncs.RateOfFireBuffRemove,
            IncludeIn = {
                T3WeaponBoosterAccuracyAdjacencyBuffs,
            },
        },

        T3WeaponBoosterEnergyWeaponTradeOff = {
            SizeData = {
                [4] = 0.025 * EnergyMaintMult,
                [8] = 0.0125 * EnergyMaintMult,
                [12] = 0.008333 * EnergyMaintMult,
                [16] = 0.00625 * EnergyMaintMult,
                [20] = 0.005 * EnergyMaintMult,
            },
            BuffType = 'DAMAGEBONUS',
            Affects = 'EnergyWeapon',
            BuffCheckFunction = AdjBuffFuncs.EnergyWeaponBuffCheck,
            OnBuffAffect = AdjBuffFuncs.EnergyWeaponBuffAffect,
            OnBuffRemove = AdjBuffFuncs.EnergyWeaponBuffRemove,
            IncludeIn = {
                T3WeaponBoosterDamageAdjacencyBuffs,
            },
        },
        T3WeaponBoosterEnergyMaintTradeOff = {
            SizeData = {
                [4] = 0.025 * EnergyMaintMult,
                [8] = 0.0125 * EnergyMaintMult,
                [12] = 0.008333 * EnergyMaintMult,
                [16] = 0.00625 * EnergyMaintMult,
                [20] = 0.005 * EnergyMaintMult,
            },
            BuffType = 'DAMAGEBONUS',
            Affects = 'EnergyMaintenance',
            BuffCheckFunction = AdjBuffFuncs.EnergyWeaponBuffCheck,
            OnBuffAffect = AdjBuffFuncs.EnergyWeaponBuffAffect,
            OnBuffRemove = AdjBuffFuncs.EnergyWeaponBuffRemove,
            IncludeIn = {
                T3WeaponBoosterDamageAdjacencyBuffs,
            },
        },

        T3ShieldBoosterMaintTradeOff = {
            SizeData = {
                [4] = 0.025 * EnergyMaintMult,
                [8] = 0.0125 * EnergyMaintMult,
                [12] = 0.008333 * EnergyMaintMult,
                [16] = 0.00625 * EnergyMaintMult,
                [20] = 0.005 * EnergyMaintMult,
            },
            BuffType = 'SHIELDBOOSTERNODE',
            Affects = 'EnergyMaintenance',
            BuffCheckFunction = hasShield,
            OnBuffAffect = AdjBuffFuncs.DefaultBuffAffect,
            OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
            IncludeIn = {
                T3ShieldBoosterRegenAdjacencyBuffs,
            },
        },
        T3ShieldBoosterRegenBonus = {
            SizeData = {
                [4] = 0.025 * ShieldRegenMult,
                [8] = 0.0125 * ShieldRegenMult,
                [12] = 0.008333 * ShieldRegenMult,
                [16] = 0.00625 * ShieldRegenMult,
                [20] = 0.005 * ShieldRegenMult,
            },
            BuffType = 'SHIELDBOOSTERNODE',
            Affects = 'ShieldRegeneration',
            BuffCheckFunction = hasShield,
            OnBuffAffect = AdjBuffFuncs.DefaultBuffAffect,
            OnBuffRemove = AdjBuffFuncs.DefaultBuffRemove,
            IncludeIn = {
                T3ShieldBoosterRegenAdjacencyBuffs,
            },
        },
    }

    for buff, data in pairs(buffs) do
        for size, val in pairs(data.SizeData) do
            local name = buff .. "Size" .. size
            local cat = 'STRUCTURE SIZE' .. tostring(size)
            BuffBlueprint({
                Name = name,
                DisplayName = buff,
                BuffType = data.BuffType,
                Stacks = 'ALWAYS',
                Duration = -1,
                EntityCategory = cat,
                BuffCheckFunction = data.BuffCheckFunction,
                OnBuffAffect = data.OnBuffAffect,
                OnBuffRemove = data.OnBuffRemove,
                Affects = {
                    [data.Affects] = {
                        Add = val,
                        Mult = 1.0,
                    },
                },
            })
            for i, v in pairs(data.IncludeIn) do
                table.insert(v,name)
            end
        end
    end
end
