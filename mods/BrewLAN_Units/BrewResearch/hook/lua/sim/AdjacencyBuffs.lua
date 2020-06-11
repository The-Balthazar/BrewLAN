--------------------------------------------------------------------------------
-- Wind turbines
--------------------------------------------------------------------------------
BuffBlueprint {
    Name = 'T1TurbineEnergyProductionBonusSize4',
    DisplayName = 'T1TurbineEnergyProductionBonusSize4',
    BuffType = 'ENERGYBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE WINDTURBINE SIZE4',
    ParsedEntityCategory = categories.STRUCTURE * categories.WINDTURBINE * categories.SIZE4,
    BuffCheckFunction = AdjBuffFuncs.EnergyProductionBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyProductionBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyProductionBuffRemove,
    Affects = {
        EnergyProduction = {
            Add = 0.4/4,
            Mult = 1.0,
        },
    },
}

do
    T1WindGeneratorAdjacencyBuffs = table.deepcopy(T1PowerGeneratorAdjacencyBuffs)
    table.insert(T1WindGeneratorAdjacencyBuffs, 'T1TurbineEnergyProductionBonusSize4')
end

--------------------------------------------------------------------------------
-- Light tech 2 energy generators
--------------------------------------------------------------------------------
T2LightPowerGeneratorAdjacencyBuffs = {}

do
    local buffs = {
        T2LightPowerEnergyBuildBonus = {
            SizeData = {
                [4] = -0.5/4,
                [8] = -0.5/4,
                [12] = -0.5/4,
                [16] = -0.5/8,
                [20] = -0.5/8,
                [24] = -0.5/12,--Stargate
                --[30] = -0.5/14,--Gantry
                [32] = -0.5/16,--Souiya
                [36] = -0.5/16,--Panopticon & Arthrolab
                [60] = -0.5/28,--Independence Engine
            },
            BuffType = 'ENERGYBUILDBONUS',
            Affects = 'EnergyActive',
            BuffCheckFunction = AdjBuffFuncs.EnergyBuildBuffCheck,
            OnBuffAffect = AdjBuffFuncs.EnergyBuildBuffAffect,
            OnBuffRemove = AdjBuffFuncs.EnergyBuildBuffRemove,
            IncludeIn = {
                T2LightPowerGeneratorAdjacencyBuffs,
            },
        },

        T2LightPowerEnergyMaintenanceBonus = {
            SizeData = {
                [4] = -0.5/4,
                [8] = -0.5/4,
                [12] = -0.5/4,
                [16] = -0.5/8,
                [20] = -0.5/8,
                [24] = -0.5/12,
                --[30] = -0.5/14,
                [32] = -0.5/16,
                [36] = -0.5/16,
                [60] = -0.5/28,
            },
            BuffType = 'ENERGYMAINTENANCEBONUS',
            Affects = 'EnergyMaintenance',
            BuffCheckFunction = AdjBuffFuncs.EnergyMaintenanceBuffCheck,
            OnBuffAffect = AdjBuffFuncs.EnergyMaintenanceBuffAffect,
            OnBuffRemove = AdjBuffFuncs.EnergyMaintenanceBuffRemove,
            IncludeIn = {
                T2LightPowerGeneratorAdjacencyBuffs,
            },
        },

        T2LightPowerEnergyWeaponBonus = {
            SizeData = {
                [4] = -0.2/4,
                [8] = -0.2/4,
                [12] = -0.2/4,
                [16] = -0.2/8,
                [20] = -0.2/8,
                [24] = -0.2/12,
                --[30] = -0.2/14,
                [32] = -0.2/16,
                [36] = -0.2/16,
                [60] = -0.2/28,
            },
            BuffType = 'ENERGYWEAPONBONUS',
            Affects = 'EnergyWeapon',
            BuffCheckFunction = AdjBuffFuncs.EnergyWeaponBuffCheck,
            OnBuffAffect = AdjBuffFuncs.EnergyWeaponBuffAffect,
            OnBuffRemove = AdjBuffFuncs.EnergyWeaponBuffRemove,
            IncludeIn = {
                T2LightPowerGeneratorAdjacencyBuffs,
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

--------------------------------------------------------------------------------
-- Unused science and manufacturing center buffs.
--------------------------------------------------------------------------------
ScienceCentreResearchBuff = {
    'ResearchMassBuildBonus',
    'ResearchEnergyBuildNerf',
}

ManufacturingCentreResearchBuff = {
    'ResearchEnergyBuildBonus',
    'ResearchMassBuildBonusNerf',
}

BuffBlueprint {Name = 'Tier2ResearchEnergyBuildBonus',
    DisplayName = 'Tier2ResearchEnergyBuildBonus',
    BuffType = 'ENERGYBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE',
    ParsedEntityCategory = categories.STRUCTURE,
    BuffCheckFunction = AdjBuffFuncs.EnergyBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyBuildBuffRemove,
    Affects = {
        EnergyActive = {
            Add = -0.375/8,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {Name = 'ResearchEnergyBuildNerf',
    DisplayName = 'ResearchEnergyBuildNerf',
    BuffType = 'ENERGYBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE',
    ParsedEntityCategory = categories.STRUCTURE,
    BuffCheckFunction = AdjBuffFuncs.EnergyBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyBuildBuffRemove,
    Affects = {
        EnergyActive = {
            Add = 0.125/8,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {Name = 'Tier2ResearchMassBuildBonus',
    DisplayName = 'Tier2ResearchMassBuildBonus',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE',
    ParsedEntityCategory = categories.STRUCTURE,
    BuffCheckFunction = AdjBuffFuncs.MassBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.MassBuildBuffRemove,
    Affects = {
        MassActive = {
            Add = -0.375/8,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {Name = 'ResearchMassBuildBonusNerf',
    DisplayName = 'ResearchMassBuildBonusNerf',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE',
    ParsedEntityCategory = categories.STRUCTURE,
    BuffCheckFunction = AdjBuffFuncs.MassBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.MassBuildBuffRemove,
    Affects = {
        MassActive = {
            Add = 0.125/8,
            Mult = 1.0,
        },
    },
}

    --[[BuildRate = {
        Add = 0.5/8,
        Mult = 1.0,
    },]]
