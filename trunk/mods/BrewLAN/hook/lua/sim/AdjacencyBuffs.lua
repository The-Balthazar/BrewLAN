##################################################################
## TIER 2 MASS STORAGE
##################################################################

T2MassStorageAdjacencyBuffs = {
    'T2MassStorageMassProductionBonusSize4',
    'T2MassStorageMassProductionBonusSize8',
    'T2MassStorageMassProductionBonusSize12',
    'T2MassStorageMassProductionBonusSize16',
    'T2MassStorageMassProductionBonusSize20',
}

##################################################################
## MASS PRODUCTION BONUS - TIER 2 MASS STORAGE
##################################################################

BuffBlueprint {
    Name = 'T2MassStorageMassProductionBonusSize4',
    DisplayName = 'T2MassStorageMassProductionBonus',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE4',
    BuffCheckFunction = AdjBuffFuncs.MassProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.MassProductionBuffRemove,
    Affects = {
        MassProduction = {
            Add = 0.125,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T2MassStorageMassProductionBonusSize8',
    DisplayName = 'T2MassStorageMassProductionBonus',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE8',
    BuffCheckFunction = AdjBuffFuncs.MassProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.MassProductionBuffRemove,
    Affects = {
        MassProduction = {
            Add = 0.0625*2,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T2MassStorageMassProductionBonusSize12',
    DisplayName = 'T2MassStorageMassProductionBonus',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE12',
    BuffCheckFunction = AdjBuffFuncs.MassProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.MassProductionBuffRemove,
    Affects = {
        MassProduction = {
            Add = 0.041667*2,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T2MassStorageMassProductionBonusSize16',
    DisplayName = 'T2MassStorageMassProductionBonus',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE16',
    BuffCheckFunction = AdjBuffFuncs.MassProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.MassProductionBuffRemove,
    Affects = {
        MassProduction = {
            Add = 0.03125*2,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T2MassStorageMassProductionBonusSize20',
    DisplayName = 'T2MassStorageMassProductionBonus',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE20',
    BuffCheckFunction = AdjBuffFuncs.MassProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.MassProductionBuffRemove,
    Affects = {
        MassProduction = {
            Add = 0.025*2,
            Mult = 1.0,
        },
    },
}