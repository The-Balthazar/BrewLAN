##################################################################
## TIER 2 ENERGY STORAGE
##################################################################

T2EnergyStorageAdjacencyBuffs = {
    'T2EnergyStorageEnergyProductionBonusSize4',
    'T2EnergyStorageEnergyProductionBonusSize8',
    'T2EnergyStorageEnergyProductionBonusSize12',
    'T2EnergyStorageEnergyProductionBonusSize16',
    'T2EnergyStorageEnergyProductionBonusSize20',
}

##################################################################
## ENERGY PRODUCTION BONUS - TIER 2 ENERGY STORAGE
##################################################################

BuffBlueprint {
    Name = 'T2EnergyStorageEnergyProductionBonusSize4',
    DisplayName = 'T2EnergyStorageEnergyProductionBonus',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE4',
    BuffCheckFunction = AdjBuffFuncs.EnergyProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyProductionBuffRemove,
    Affects = {
        EnergyProduction = {
            Add = 0.125*4,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T2EnergyStorageEnergyProductionBonusSize8',
    DisplayName = 'T2EnergyStorageEnergyProductionBonus',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE8',
    BuffCheckFunction = AdjBuffFuncs.EnergyProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyProductionBuffRemove,
    Affects = {
        EnergyProduction = {
            Add = 0.0625*8,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T2EnergyStorageEnergyProductionBonusSize12',
    DisplayName = 'T2EnergyStorageEnergyProductionBonus',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE12',
    BuffCheckFunction = AdjBuffFuncs.EnergyProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyProductionBuffRemove,
    Affects = {
        EnergyProduction = {
            Add = 0.041667*12,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T2EnergyStorageEnergyProductionBonusSize16',
    DisplayName = 'T2EnergyStorageEnergyProductionBonus',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE16',
    BuffCheckFunction = AdjBuffFuncs.EnergyProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyProductionBuffRemove,
    Affects = {
        EnergyProduction = {
            Add = 0.03125*8,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T2EnergyStorageEnergyProductionBonusSize20',
    DisplayName = 'T3EnergyStorageEnergyProductionBonus',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE20',
    BuffCheckFunction = AdjBuffFuncs.EnergyProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyProductionBuffRemove,
    Affects = {
        EnergyProduction = {
            Add = 0.025*10,
            Mult = 1.0,
        },
    },
}

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
            Add = 0.041667*3,
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
            Add = 0.025*2.5,
            Mult = 1.0,
        },
    },
}

##################################################################
## GANTRY SIZE 30 PRODUCTION BONUSES
##################################################################

BuffBlueprint {
    Name = 'T1PowerEnergyBuildBonusSize30',
    DisplayName = 'T1PowerEnergyBuildBonus',
    BuffType = 'ENERGYBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE30',
    BuffCheckFunction = AdjBuffFuncs.EnergyBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyBuildBuffRemove,
    Affects = {
        EnergyActive = {
            Add = -0.0125/3*2,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T2PowerEnergyBuildBonusSize30',
    DisplayName = 'T2PowerEnergyBuildBonus',
    BuffType = 'ENERGYBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE30',
    BuffCheckFunction = AdjBuffFuncs.EnergyBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyBuildBuffRemove,
    Affects = {
        EnergyActive = {
            Add = -0.0125/3*2,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T3PowerEnergyBuildBonusSize30',
    DisplayName = 'T3PowerEnergyBuildBonus',
    BuffType = 'ENERGYBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE30',
    BuffCheckFunction = AdjBuffFuncs.EnergyBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyBuildBuffRemove,
    Affects = {
        EnergyActive = {
            Add = -0.1875/3*2,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T1MEXMassBuildBonusSize30',
    DisplayName = 'T1MEXMassBuildBonus',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE30',
    BuffCheckFunction = AdjBuffFuncs.MassBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.MassBuildBuffRemove,
    Affects = {
        MassActive = {
            Add = -0.02/3*2,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T2MEXMassBuildBonusSize30',
    DisplayName = 'T2MEXMassBuildBonus',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE30',
    BuffCheckFunction = AdjBuffFuncs.MassBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.MassBuildBuffRemove,
    Affects = {
        MassActive = {
            Add = -0.03/3*2,
            Mult = 1.0,
        },
    },
}


BuffBlueprint {
    Name = 'T3MEXMassBuildBonusSize30',
    DisplayName = 'T3MEXMassBuildBonus',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE30',
    BuffCheckFunction = AdjBuffFuncs.MassBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.MassBuildBuffRemove,
    Affects = {
        MassActive = {
            Add = -0.04/3*2,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T1FabricatorMassBuildBonusSize30',
    DisplayName = 'T1FabricatorMassBuildBonus',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE30',
    BuffCheckFunction = AdjBuffFuncs.MassBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.MassBuildBuffRemove,
    Affects = {
        MassActive = {
            Add = -0.005/3*2,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'T3FabricatorMassBuildBonusSize30',
    DisplayName = 'T3FabricatorMassBuildBonus',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE SIZE30',
    BuffCheckFunction = AdjBuffFuncs.MassBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.MassBuildBuffRemove,
    Affects = {
        MassActive = {
            Add = -0.075/3*2,
            Mult = 1.0,
        },
    },
}


do
    table.insert(T1PowerGeneratorAdjacencyBuffs, 'T1PowerEnergyBuildBonusSize30')
    table.insert(T2PowerGeneratorAdjacencyBuffs, 'T2PowerEnergyBuildBonusSize30')
    table.insert(T3PowerGeneratorAdjacencyBuffs, 'T3PowerEnergyBuildBonusSize30')
    
    table.insert(HydrocarbonAdjacencyBuffs, 'T2PowerEnergyBuildBonusSize30')
    
    table.insert(T1MassExtractorAdjacencyBuffs, 'T1MEXMassBuildBonusSize30')
    table.insert(T2MassExtractorAdjacencyBuffs, 'T2MEXMassBuildBonusSize30')
    table.insert(T3MassExtractorAdjacencyBuffs, 'T3MEXMassBuildBonusSize30')  
    
    table.insert(T1MassFabricatorAdjacencyBuffs, 'T1FabricatorMassBuildBonusSize30') 
    table.insert(T3MassFabricatorAdjacencyBuffs, 'T3FabricatorMassBuildBonusSize30')
end
     
##################################################################
## PARAGON ADJACENCY BONUSES BECAUSE WHY NOT
##################################################################

ParagonAdjacencyBuffs = {
    'ParagonEnergyBuildBonus',
    'ParagonEnergyMaintenanceBonus',
    'ParagonEnergyWeaponBonus',
    'ParagonRateOfFireBonus',
    'ParagonMassBuildBonus',
}  
   
BuffBlueprint {
    Name = 'ParagonEnergyBuildBonus',
    DisplayName = 'ParagonEnergyBuildBonus',
    BuffType = 'ENERGYBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE',
    BuffCheckFunction = AdjBuffFuncs.EnergyBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyBuildBuffRemove,
    Affects = {
        EnergyActive = {
            Add = -1,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'ParagonEnergyMaintenanceBonus',
    DisplayName = 'ParagonEnergyMaintenanceBonus',
    BuffType = 'ENERGYMAINTENANCEBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE',
    BuffCheckFunction = AdjBuffFuncs.EnergyMaintenanceBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyMaintenanceBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyMaintenanceBuffRemove,
    Affects = {
        EnergyMaintenance = {
            Add = 0,
            Mult = 0.1,
        },
    },
}

BuffBlueprint {
    Name = 'ParagonEnergyWeaponBonus',
    DisplayName = 'ParagonEnergyWeaponBonus',
    BuffType = 'ENERGYWEAPONBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE',
    BuffCheckFunction = AdjBuffFuncs.EnergyWeaponBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyWeaponBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyWeaponBuffRemove,
    Affects = {
        EnergyWeapon = {
            Add = 0,
            Mult = .1,
        },
    },
}

BuffBlueprint {
    Name = 'ParagonRateOfFireBonus',
    DisplayName = 'ParagonRateOfFireBonus',
    BuffType = 'RATEOFFIREADJACENCY',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE',
    BuffCheckFunction = AdjBuffFuncs.RateOfFireBuffCheck,
    OnBuffAffect = AdjBuffFuncs.RateOfFireBuffAffect,
    OnBuffRemove = AdjBuffFuncs.RateOfFireBuffRemove,
    Affects = {
        RateOfFire = {
            Add = 0,
            Mult = .65,
        },
    },
}
    
BuffBlueprint {
    Name = 'ParagonMassBuildBonus',
    DisplayName = 'ParagonMassBuildBonus',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE',
    BuffCheckFunction = AdjBuffFuncs.MassBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.MassBuildBuffRemove,
    Affects = {
        MassActive = {
            Add = -1,
            Mult = 1.0,
        },
    },
}

