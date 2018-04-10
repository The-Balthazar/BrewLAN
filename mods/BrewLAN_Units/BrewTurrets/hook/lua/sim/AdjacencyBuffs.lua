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

T3WeaponBoosterDamageAdjacencyBuffs = {
    --'T3WeaponBoosterDamageBonusSize4',
    --'T3WeaponBoosterDamageBonusSize8',
    --'T3WeaponBoosterDamageBonusSize12',
    --'T3WeaponBoosterDamageBonusSize16',
    --'T3WeaponBoosterDamageBonusSize20',
    'T3WeaponBoosterEnergyWeaponTradeOffSize4',
    'T3WeaponBoosterEnergyWeaponTradeOffSize8',
    'T3WeaponBoosterEnergyWeaponTradeOffSize12',
    'T3WeaponBoosterEnergyWeaponTradeOffSize16',
    'T3WeaponBoosterEnergyWeaponTradeOffSize20',
}

------------------------------------------------------------------
-- Accuracy boosts
------------------------------------------------------------------
local AccuracyMult = 5     -- 10% max, multiplied by
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
    BuffType = 'ACCURACYBONUS',
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
-- RATE OF FIRE NERFS
------------------------------------------------------------------

BuffBlueprint {
    Name = 'T3WeaponBoosterRateOfFireTradeOffSize4',
    DisplayName = 'T3WeaponBoosterRateOfFireTradeOff',
    BuffType = 'RATEOFFIREADJACENCY',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE4',
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

------------------------------------------------------------------
-- Energy cost increases
------------------------------------------------------------------
local EnergyDamageMult = 40     -- 10% max, multiplied by
BuffBlueprint {
    Name = 'T3WeaponBoosterEnergyWeaponTradeOffSize4',
    DisplayName = 'T3WeaponBoosterEnergyWeaponTradeOff',
    BuffType = 'ENERGYWEAPONBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE4',
    BuffCheckFunction = AdjBuffFuncs.EnergyWeaponBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyWeaponBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyWeaponBuffRemove,
    Affects = {
        EnergyWeapon = {
            Add = 0.025 * EnergyDamageMult,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T3WeaponBoosterEnergyWeaponTradeOffSize8',
    DisplayName = 'T3WeaponBoosterEnergyWeaponTradeOff',
    BuffType = 'ENERGYWEAPONBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE8',
    BuffCheckFunction = AdjBuffFuncs.EnergyWeaponBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyWeaponBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyWeaponBuffRemove,
    Affects = {
        EnergyWeapon = {
            Add = 0.0125 * EnergyDamageMult,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T3WeaponBoosterEnergyWeaponTradeOffSize12',
    DisplayName = 'T3WeaponBoosterEnergyWeaponTradeOff',
    BuffType = 'ENERGYWEAPONBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE12',
    BuffCheckFunction = AdjBuffFuncs.EnergyWeaponBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyWeaponBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyWeaponBuffRemove,
    Affects = {
        EnergyWeapon = {
            Add = 0.008333 * EnergyDamageMult,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T3WeaponBoosterEnergyWeaponTradeOffSize16',
    DisplayName = 'T3WeaponBoosterEnergyWeaponTradeOff',
    BuffType = 'ENERGYWEAPONBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE16',
    BuffCheckFunction = AdjBuffFuncs.EnergyWeaponBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyWeaponBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyWeaponBuffRemove,
    Affects = {
        EnergyWeapon = {
            Add = 0.00625 * EnergyDamageMult,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T3WeaponBoosterEnergyWeaponTradeOffSize20',
    DisplayName = 'T3WeaponBoosterEnergyWeaponTradeOff',
    BuffType = 'ENERGYWEAPONBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE20',
    BuffCheckFunction = AdjBuffFuncs.EnergyWeaponBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyWeaponBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyWeaponBuffRemove,
    Affects = {
        EnergyWeapon = {
            Add = 0.005 * EnergyDamageMult,
            Mult = 1.0,
        },
    },
}
------------------------------------------------------------------
-- Damage boosts -- WARNING TO OTHERS, THESE DON'T WORK
------------------------------------------------------------------
local DamageMult = 0     -- 10% max, multiplied by
BuffBlueprint {
    Name = 'T3WeaponBoosterDamageBonusSize4',
    DisplayName = 'T3WeaponBoosterDamageBonus',
    BuffType = 'DAMAGEBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE4',
    BuffCheckFunction = AdjBuffFuncs.RateOfFireBuffCheck,
    OnBuffAffect = AdjBuffFuncs.RateOfFireBuffAffect,
    OnBuffRemove = AdjBuffFuncs.RateOfFireBuffRemove,
    Affects = {
        Damage = {
            Add = 0.025 * DamageMult,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T3WeaponBoosterDamageBonusSize8',
    DisplayName = 'T3WeaponBoosterDamageBonus',
    BuffType = 'DAMAGEBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE8',
    BuffCheckFunction = AdjBuffFuncs.RateOfFireBuffCheck,
    OnBuffAffect = AdjBuffFuncs.RateOfFireBuffAffect,
    OnBuffRemove = AdjBuffFuncs.RateOfFireBuffRemove,
    Affects = {
        Damage = {
            Add = 0.0125 * DamageMult,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T3WeaponBoosterDamageBonusSize12',
    DisplayName = 'T3WeaponBoosterDamageBonus',
    BuffType = 'DAMAGEBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE12',
    BuffCheckFunction = AdjBuffFuncs.RateOfFireBuffCheck,
    OnBuffAffect = AdjBuffFuncs.RateOfFireBuffAffect,
    OnBuffRemove = AdjBuffFuncs.RateOfFireBuffRemove,
    Affects = {
        Damage = {
            Add = 0.008333 * DamageMult,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T3WeaponBoosterDamageBonusSize16',
    DisplayName = 'T3WeaponBoosterDamageBonus',
    BuffType = 'DAMAGEBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE16',
    BuffCheckFunction = AdjBuffFuncs.RateOfFireBuffCheck,
    OnBuffAffect = AdjBuffFuncs.RateOfFireBuffAffect,
    OnBuffRemove = AdjBuffFuncs.RateOfFireBuffRemove,
    Affects = {
        Damage = {
            Add = 0.00625 * DamageMult,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T3WeaponBoosterDamageBonusSize20',
    DisplayName = 'T3WeaponBoosterDamageBonus',
    BuffType = 'DAMAGEBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE20',
    BuffCheckFunction = AdjBuffFuncs.RateOfFireBuffCheck,
    OnBuffAffect = AdjBuffFuncs.RateOfFireBuffAffect,
    OnBuffRemove = AdjBuffFuncs.RateOfFireBuffRemove,
    Affects = {
        Damage = {
            Add = 0.005 * DamageMult,
            Mult = 1.0,
        },
    },
}
