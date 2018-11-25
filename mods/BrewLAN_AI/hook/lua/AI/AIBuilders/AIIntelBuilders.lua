BuilderGroup {
    BuilderGroupName = 'UEFOpticsEngineerBuilders',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'T3 Optics Construction UEF',
        PlatoonTemplate = 'UEFT3EngineerBuilder',
        Priority = 750,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.OPTICS * categories.UEF}},
            { EBC, 'GreaterThanEconIncome', { 12, 1500}},
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                AdjacencyCategory = 'ENERGYPRODUCTION',
                AdjacencyDistance = 100,
                BuildClose = false,
                BuildStructures = {
                    'T3Optics',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'T4 Optics Construction UEF',
        PlatoonTemplate = 'UEFT3EngineerBuilder',
        Priority = 700,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.EXPERIMENTAL * categories.INTELLIGENCE * categories.SATELLITEUPLINK}},
            { EBC, 'GreaterThanEconIncome', { 12, 5500}},
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.4 }},
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                AdjacencyCategory = 'ENERGYPRODUCTION',
                AdjacencyDistance = 100,
                BuildClose = false,
                BuildStructures = {
                    'T4Optics',
                },
                Location = 'LocationType',
            }
        }
    }
}

BuilderGroup {
    BuilderGroupName = 'SeraphimOpticsEngineerBuilders',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'T3 Optics Construction SERAPHIM',
        PlatoonTemplate = 'SeraphimT3EngineerBuilder',
        Priority = 750,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.OPTICS * categories.SERAPHIM}},
            { EBC, 'GreaterThanEconIncome', { 12, 1500}},
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                AdjacencyCategory = 'ENERGYPRODUCTION',
                AdjacencyDistance = 100,
                BuildClose = false,
                BuildStructures = {
                    'T3Optics',
                },
                Location = 'LocationType',
            }
        }
    }
}
