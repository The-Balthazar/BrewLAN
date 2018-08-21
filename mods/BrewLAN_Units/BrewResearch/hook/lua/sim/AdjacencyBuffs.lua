BuffBlueprint {
    Name = 'T1TurbineEnergyProductionBonusSize4',
    DisplayName = 'T1TurbineEnergyProductionBonusSize4',
    BuffType = 'ENERGYBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE WINDTURBINE SIZE4',
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


ScienceCentreResearchBuff = {
    'ResearchMassBuildBonus',
    'ResearchEnergyBuildNerf',
}

ManufacturingCentreResearchBuff = {
    'ResearchEnergyBuildBonus',
    'ResearchMassBuildBonusNerf',
}

BuffBlueprint {
    Name = 'Tier2ResearchEnergyBuildBonus',
    DisplayName = 'Tier2ResearchEnergyBuildBonus',
    BuffType = 'ENERGYBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE',
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

BuffBlueprint {
    Name = 'ResearchEnergyBuildNerf',
    DisplayName = 'ResearchEnergyBuildNerf',
    BuffType = 'ENERGYBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE',
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

BuffBlueprint {
    Name = 'Tier2ResearchMassBuildBonus',
    DisplayName = 'Tier2ResearchMassBuildBonus',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE',
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

BuffBlueprint {
    Name = 'ResearchMassBuildBonusNerf',
    DisplayName = 'ResearchMassBuildBonusNerf',
    BuffType = 'MASSBUILDBONUS',
    Stacks = 'ALWAYS',
    Duration = -1,
    EntityCategory = 'STRUCTURE',
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
