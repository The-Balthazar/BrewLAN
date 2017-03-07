------------------------------------------------------------------
-- TIER 1 POWER GEN BUFF TABLE
------------------------------------------------------------------

T3WeaponBoosterAccuracyAdjacencyBuffs = {
    'T3WeaponBoosterAccuracyBonusSize4',
    'T3WeaponBoosterAccuracyBonusSize8',
    'T3WeaponBoosterAccuracyBonusSize12',
    'T3WeaponBoosterAccuracyBonusSize16',
    'T3WeaponBoosterAccuracyBonusSize20',
    'T3WeaponBoosterRateOfFireTradeOffSize4',
    'T3WeaponBoosterRateOfFireTradeOffSize8',
    'T3WeaponBoosterRateOfFireTradeOffSize12',
    'T3WeaponBoosterRateOfFireTradeOffSize16',
    'T3WeaponBoosterRateOfFireTradeOffSize20',
}

------------------------------------------------------------------
-- ENERGY WEAPON BONUS - TIER 1 POWER GENS
------------------------------------------------------------------
local AccuracyMult = 5
BuffBlueprint {
    Name = 'T3WeaponBoosterAccuracyBonusSize4',
    DisplayName = 'T3WeaponBoosterAccuracyBonus',
    BuffType = 'ACCURACYBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE4',
    BuffCheckFunction = AdjBuffFuncs.RateOfFireBuffCheck,
    OnBuffAffect = AdjBuffFuncs.RateOfFireBuffAffect,
    OnBuffRemove = AdjBuffFuncs.RateOfFireBuffRemove,
    Affects = {
        FiringRandomness = {
            Add = -0.025 * AccuracyMult,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T3WeaponBoosterAccuracyBonusSize8',
    DisplayName = 'T3WeaponBoosterAccuracyBonus',
    BuffType = 'ACCURACYBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE8',
    BuffCheckFunction = AdjBuffFuncs.RateOfFireBuffCheck,
    OnBuffAffect = AdjBuffFuncs.RateOfFireBuffAffect,
    OnBuffRemove = AdjBuffFuncs.RateOfFireBuffRemove,
    Affects = {
        FiringRandomness = {
            Add = -0.0125 * AccuracyMult,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T3WeaponBoosterAccuracyBonusSize12',
    DisplayName = 'T3WeaponBoosterAccuracyBonus',
    BuffType = 'ACCURACYBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE12',
    BuffCheckFunction = AdjBuffFuncs.RateOfFireBuffCheck,
    OnBuffAffect = AdjBuffFuncs.RateOfFireBuffAffect,
    OnBuffRemove = AdjBuffFuncs.RateOfFireBuffRemove,
    Affects = {
        FiringRandomness = {
            Add = -0.008333 * AccuracyMult,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T3WeaponBoosterAccuracyBonusSize16',
    DisplayName = 'T3WeaponBoosterAccuracyBonus',
    BuffType = 'ACCURACYBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE16',
    BuffCheckFunction = AdjBuffFuncs.RateOfFireBuffCheck,
    OnBuffAffect = AdjBuffFuncs.RateOfFireBuffAffect,
    OnBuffRemove = AdjBuffFuncs.RateOfFireBuffRemove,
    Affects = {
        FiringRandomness = {
            Add = -0.00625 * AccuracyMult,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T3WeaponBoosterAccuracyBonusSize20',
    DisplayName = 'T3WeaponBoosterAccuracyBonus',
    BuffType = 'ENERGYWEAPONBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE20',
    BuffCheckFunction = AdjBuffFuncs.RateOfFireBuffCheck,
    OnBuffAffect = AdjBuffFuncs.RateOfFireBuffAffect,
    OnBuffRemove = AdjBuffFuncs.RateOfFireBuffRemove,
    Affects = {
        FiringRandomness = {
            Add = -0.005 * AccuracyMult,
            Mult = 1.0,
        },
    },
}

------------------------------------------------------------------
-- RATE OF FIRE WEAPON BONUS - TIER 1 POWER GENS
------------------------------------------------------------------

BuffBlueprint {
    Name = 'T3WeaponBoosterRateOfFireTradeOffSize4',
    DisplayName = 'T3WeaponBoosterRateOfFireTradeOff',
    BuffType = 'RATEOFFIREADJACENCY',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE4 ARTILLERY',
    BuffCheckFunction = AdjBuffFuncs.RateOfFireBuffCheck,
    OnBuffAffect = AdjBuffFuncs.RateOfFireBuffAffect,
    OnBuffRemove = AdjBuffFuncs.RateOfFireBuffRemove,
    Affects = {
        RateOfFire = {
            Add = 0.025 * AccuracyMult,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T3WeaponBoosterRateOfFireTradeOffSize8',
    DisplayName = 'T3WeaponBoosterRateOfFireTradeOff',
    BuffType = 'RATEOFFIREADJACENCY',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE8',
    BuffCheckFunction = AdjBuffFuncs.RateOfFireBuffCheck,
    OnBuffAffect = AdjBuffFuncs.RateOfFireBuffAffect,
    OnBuffRemove = AdjBuffFuncs.RateOfFireBuffRemove,
    Affects = {
        RateOfFire = {
            Add = 0.0125 * AccuracyMult,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T3WeaponBoosterRateOfFireTradeOffSize12',
    DisplayName = 'T3WeaponBoosterRateOfFireTradeOff',
    BuffType = 'RATEOFFIREADJACENCY',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE12',
    BuffCheckFunction = AdjBuffFuncs.RateOfFireBuffCheck,
    OnBuffAffect = AdjBuffFuncs.RateOfFireBuffAffect,
    OnBuffRemove = AdjBuffFuncs.RateOfFireBuffRemove,
    Affects = {
        RateOfFire = {
            Add = 0.008333 * AccuracyMult,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T3WeaponBoosterRateOfFireTradeOffSize16',
    DisplayName = 'T3WeaponBoosterRateOfFireTradeOff',
    BuffType = 'RATEOFFIREADJACENCY',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE16',
    BuffCheckFunction = AdjBuffFuncs.RateOfFireBuffCheck,
    OnBuffAffect = AdjBuffFuncs.RateOfFireBuffAffect,
    OnBuffRemove = AdjBuffFuncs.RateOfFireBuffRemove,
    Affects = {
        RateOfFire = {
            Add = 0.00625 * AccuracyMult,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T3WeaponBoosterRateOfFireTradeOffSize20',
    DisplayName = 'T3WeaponBoosterRateOfFireTradeOff',
    BuffType = 'RATEOFFIREADJACENCY',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE20',
    BuffCheckFunction = AdjBuffFuncs.RateOfFireBuffCheck,
    OnBuffAffect = AdjBuffFuncs.RateOfFireBuffAffect,
    OnBuffRemove = AdjBuffFuncs.RateOfFireBuffRemove,
    Affects = {
        RateOfFire = {
            Add = 0.005 * AccuracyMult,
            Mult = 1.0,
        },
    },
}
