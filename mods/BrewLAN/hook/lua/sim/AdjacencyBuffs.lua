------------------------------------------------------------------
-- TIER 2 STORAGE
------------------------------------------------------------------
T2Size8EnergyStorageAdjacencyBuffs = {}
T2Size8MassStorageAdjacencyBuffs = {}
------------------------------------------------------------------
do
    local buffs = {
        ---------------------------------------------------------
        -- T2 Storage
        ---------------------------------------------------------
        T2Size8EnergyStorageEnergyProductionBonus = {
            SizeData = {
                [4] = 0.125*4,
                [8] = 0.0625*8,
                [12] = 0.041667*12,
                [16] = 0.03125*8,
                [20] = 0.025*10,
            },
            BuffType = 'MASSBUILDBONUS',
            Affects = 'EnergyProduction',
            BuffCheckFunction = AdjBuffFuncs.EnergyProductionBuffCheck,
            OnBuffAffect = AdjBuffFuncs.EnergyProductionBuffAffect,
            OnBuffRemove = AdjBuffFuncs.EnergyProductionBuffRemove,
            IncludeIn = {
                T2Size8EnergyStorageAdjacencyBuffs,
            },
        },
        T2Size8MassStorageMassProductionBonus = {
            SizeData = {
                [4] = 0.125,
                [8] = 0.0625*2,
                [12] = 0.041667*3,
                [16] = 0.03125*2,
                [20] = 0.025*2.5,
            },
            BuffType = 'MASSBUILDBONUS',
            Affects = 'MassProduction',
            BuffCheckFunction = AdjBuffFuncs.MassProductionBuffCheck,
            OnBuffAffect = AdjBuffFuncs.MassProductionBuffAffect,
            OnBuffRemove = AdjBuffFuncs.MassProductionBuffRemove,
            IncludeIn = {
                T2Size8MassStorageAdjacencyBuffs,
            },
        },
        ---------------------------------------------------------
        -- Large building active power buff
        ---------------------------------------------------------
        T1PowerEnergyBuildBonus = {
            SizeData = {
                [24] = -0.25/24,
                [30] = -0.25/30,
                [32] = -0.25/32,
                [36] = -0.25/36,
                [60] = -0.25/60,
            },
            BuffType = 'ENERGYBUILDBONUS',
            Affects = 'EnergyActive',
            BuffCheckFunction = AdjBuffFuncs.EnergyBuildBuffCheck,
            OnBuffAffect = AdjBuffFuncs.EnergyBuildBuffAffect,
            OnBuffRemove = AdjBuffFuncs.EnergyBuildBuffRemove,
            IncludeIn = {
                T1PowerGeneratorAdjacencyBuffs,
            },
        },
        T2PowerEnergyBuildBonus = {
            SizeData = {
                [24] = -0.5/8,
                [30] = -0.5/10,
                [32] = -0.5/8,
                [36] = -0.5/12,
                [60] = -0.5/20,
            },
            BuffType = 'ENERGYBUILDBONUS',
            Affects = 'EnergyActive',
            BuffCheckFunction = AdjBuffFuncs.EnergyBuildBuffCheck,
            OnBuffAffect = AdjBuffFuncs.EnergyBuildBuffAffect,
            OnBuffRemove = AdjBuffFuncs.EnergyBuildBuffRemove,
            IncludeIn = {
                T2PowerGeneratorAdjacencyBuffs,
                HydrocarbonAdjacencyBuffs,
            },
        },
        T3PowerEnergyBuildBonus = {
            SizeData = {
                [24] = -0.75/4,
                [30] = -0.75/6,
                [32] = -0.75/8,
                [36] = -0.75/8,
                [60] = -0.75/12,
            },
            BuffType = 'ENERGYBUILDBONUS',
            Affects = 'EnergyActive',
            BuffCheckFunction = AdjBuffFuncs.EnergyBuildBuffCheck,
            OnBuffAffect = AdjBuffFuncs.EnergyBuildBuffAffect,
            OnBuffRemove = AdjBuffFuncs.EnergyBuildBuffRemove,
            IncludeIn = {
                T3PowerGeneratorAdjacencyBuffs,
            },
        },
        ---------------------------------------------------------
        -- Large building maintenance buff
        ---------------------------------------------------------
        T1PowerEnergyMaintenanceBonus = {
            SizeData = {
                [24] = -0.25/24,
                [30] = -0.25/30,
                [32] = -0.25/32,
                [36] = -0.25/36,
                [60] = -0.25/60,
            },
            BuffType = 'ENERGYMAINTENANCEBONUS',
            Affects = 'EnergyMaintenance',
            BuffCheckFunction = AdjBuffFuncs.EnergyMaintenanceBuffCheck,
            OnBuffAffect = AdjBuffFuncs.EnergyMaintenanceBuffAffect,
            OnBuffRemove = AdjBuffFuncs.EnergyMaintenanceBuffRemove,
            IncludeIn = {
                T1PowerGeneratorAdjacencyBuffs,
            },
        },
        T2PowerEnergyMaintenanceBonus = {
            SizeData = {
                [24] = -0.5/8,
                [30] = -0.5/10,
                [32] = -0.5/8,
                [36] = -0.5/12,
                [60] = -0.5/20,
            },
            BuffType = 'ENERGYMAINTENANCEBONUS',
            Affects = 'EnergyMaintenance',
            BuffCheckFunction = AdjBuffFuncs.EnergyMaintenanceBuffCheck,
            OnBuffAffect = AdjBuffFuncs.EnergyMaintenanceBuffAffect,
            OnBuffRemove = AdjBuffFuncs.EnergyMaintenanceBuffRemove,
            IncludeIn = {
                T2PowerGeneratorAdjacencyBuffs,
                HydrocarbonAdjacencyBuffs,
            },
        },
        T3PowerEnergyMaintenanceBonus = {
            SizeData = {
                [24] = -0.75/4,
                [30] = -0.75/6,
                [32] = -0.75/8,
                [36] = -0.75/8,
                [60] = -0.75/12,
            },
            BuffType = 'ENERGYMAINTENANCEBONUS',
            Affects = 'EnergyMaintenance',
            BuffCheckFunction = AdjBuffFuncs.EnergyMaintenanceBuffCheck,
            OnBuffAffect = AdjBuffFuncs.EnergyMaintenanceBuffAffect,
            OnBuffRemove = AdjBuffFuncs.EnergyMaintenanceBuffRemove,
            IncludeIn = {
                T3PowerGeneratorAdjacencyBuffs,
            },
        },
        ---------------------------------------------------------
        -- Large building energy weapon costs buff
        ---------------------------------------------------------
        T1PowerEnergyWeaponBonus = {
            SizeData = {
                [24] = -0.1/24,
                [30] = -0.1/30,
                [32] = -0.1/32,
                [36] = -0.1/36,
                [60] = -0.1/60,
            },
            BuffType = 'ENERGYWEAPONBONUS',
            Affects = 'EnergyWeapon',
            BuffCheckFunction = AdjBuffFuncs.EnergyWeaponBuffCheck,
            OnBuffAffect = AdjBuffFuncs.EnergyWeaponBuffAffect,
            OnBuffRemove = AdjBuffFuncs.EnergyWeaponBuffRemove,
            IncludeIn = {
                T1PowerGeneratorAdjacencyBuffs,
            },
        },
        T2PowerEnergyWeaponBonus = {
            SizeData = {
                [24] = -0.2/8,
                [30] = -0.2/10,
                [32] = -0.2/8,
                [36] = -0.2/12,
                [60] = -0.2/20,
            },
            BuffType = 'ENERGYWEAPONBONUS',
            Affects = 'EnergyWeapon',
            BuffCheckFunction = AdjBuffFuncs.EnergyWeaponBuffCheck,
            OnBuffAffect = AdjBuffFuncs.EnergyWeaponBuffAffect,
            OnBuffRemove = AdjBuffFuncs.EnergyWeaponBuffRemove,
            IncludeIn = {
                T2PowerGeneratorAdjacencyBuffs,
                HydrocarbonAdjacencyBuffs,
            },
        },
        T3PowerEnergyWeaponBonus = {
            SizeData = {
                [24] = -0.3/4,
                [30] = -0.3/6,
                [32] = -0.3/8,
                [36] = -0.3/8,
                [60] = -0.3/12,
            },
            BuffType = 'ENERGYWEAPONBONUS',
            Affects = 'EnergyWeapon',
            BuffCheckFunction = AdjBuffFuncs.EnergyWeaponBuffCheck,
            OnBuffAffect = AdjBuffFuncs.EnergyWeaponBuffAffect,
            OnBuffRemove = AdjBuffFuncs.EnergyWeaponBuffRemove,
            IncludeIn = {
                T3PowerGeneratorAdjacencyBuffs,
            },
        },
        ---------------------------------------------------------
        -- Large building extractor active buffs
        ---------------------------------------------------------
        T1MEXMassBuildBonus = {
            SizeData = {
                [24] = -0.4/24,
                [30] = -0.4/30,
                [32] = -0.4/32,
                [36] = -0.4/36,
                [60] = -0.4/60,
            },
            BuffType = 'MASSBUILDBONUS',
            Affects = 'MassActive',
            BuffCheckFunction = AdjBuffFuncs.MassBuildBuffCheck,
            OnBuffAffect = AdjBuffFuncs.MassBuildBuffAffect,
            OnBuffRemove = AdjBuffFuncs.MassBuildBuffRemove,
            IncludeIn = {
                T1MassExtractorAdjacencyBuffs,
            },
        },
        T2MEXMassBuildBonus = {
            SizeData = {
                [24] = -0.6/24,
                [30] = -0.6/30,
                [32] = -0.6/32,
                [36] = -0.6/36,
                [60] = -0.6/60,
            },
            BuffType = 'MASSBUILDBONUS',
            Affects = 'MassActive',
            BuffCheckFunction = AdjBuffFuncs.MassBuildBuffCheck,
            OnBuffAffect = AdjBuffFuncs.MassBuildBuffAffect,
            OnBuffRemove = AdjBuffFuncs.MassBuildBuffRemove,
            IncludeIn = {
                T2MassExtractorAdjacencyBuffs,
            },
        },
        T3MEXMassBuildBonus = {
            SizeData = {
                [24] = -0.8/24,
                [30] = -0.8/30,
                [32] = -0.8/32,
                [36] = -0.8/36,
                [60] = -0.8/60,
            },
            BuffType = 'MASSBUILDBONUS',
            Affects = 'MassActive',
            BuffCheckFunction = AdjBuffFuncs.MassBuildBuffCheck,
            OnBuffAffect = AdjBuffFuncs.MassBuildBuffAffect,
            OnBuffRemove = AdjBuffFuncs.MassBuildBuffRemove,
            IncludeIn = {
                T3MassExtractorAdjacencyBuffs,
            },
        },
        ---------------------------------------------------------
        -- Large building fabricator active buffs
        ---------------------------------------------------------
        T1FabricatorMassBuildBonus = {
            SizeData = {
                [24] = -0.1/24,
                [30] = -0.1/30,
                [32] = -0.1/32,
                [36] = -0.1/36,
                [60] = -0.1/60,
            },
            BuffType = 'MASSBUILDBONUS',
            Affects = 'MassActive',
            BuffCheckFunction = AdjBuffFuncs.MassBuildBuffCheck,
            OnBuffAffect = AdjBuffFuncs.MassBuildBuffAffect,
            OnBuffRemove = AdjBuffFuncs.MassBuildBuffRemove,
            IncludeIn = {
                T1MassFabricatorAdjacencyBuffs,
            },
        },
        T3FabricatorMassBuildBonus = {
            SizeData = {
                [24] = -0.3/8,
                [30] = -0.3/10,
                [32] = -0.3/8,
                [36] = -0.3/12,
                [60] = -0.3/20,
            },
            BuffType = 'MASSBUILDBONUS',
            Affects = 'MassActive',
            BuffCheckFunction = AdjBuffFuncs.MassBuildBuffCheck,
            OnBuffAffect = AdjBuffFuncs.MassBuildBuffAffect,
            OnBuffRemove = AdjBuffFuncs.MassBuildBuffRemove,
            IncludeIn = {
                T3MassFabricatorAdjacencyBuffs,
            },
        },
    }
    ---------------------------------------------------------
    -- AVENGERS ASSEMBLE
    ---------------------------------------------------------
    for buff, data in buffs do
        for size, val in data.SizeData do
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
            for i, v in data.IncludeIn do
                table.insert(v,name)
            end
        end
    end
end
-- Size                             -   8-  12-  16-
-- Size60 - Independance Engine     - 28 - 20 - 12 -
-- Size36 - Panopticon, Arthrolab   - 16 - 12 -  8 -
-- Size32 - Souiya                  - 16 -  8 -  8 -
-- Size30 - Gantry                  - 14 - 10 -  6 -
-- Size24 - Chappa'ai               - 12 -  8 -  4 -

------------------------------------------------------------------
-- PARAGON ADJACENCY BONUSES BECAUSE WHY NOT
------------------------------------------------------------------

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
