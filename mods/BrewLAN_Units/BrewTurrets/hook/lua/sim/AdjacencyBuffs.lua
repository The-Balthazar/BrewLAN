------------------------------------------------------------------
-- TIER 1 POWER GEN BUFF TABLE
------------------------------------------------------------------

T3WeaponBoosterAccuracyAdjacencyBuffs = {}
T3WeaponBoosterDamageAdjacencyBuffs = {}

do
    local AccuracyMult = 5     -- 10% max, multiplied by
    local EnergyMaintMult = 40

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
