BuilderGroup {
    BuilderGroupName = 'MetalWorldMassBuilders',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'MetalWorldMassEngineer',
        PlatoonTemplate = 'EngineerBuilder',
        Priority = 1250,
        BuilderConditions = {
            --{ EBC, 'LessThanEconStorageRatio', { 0.9, 2 } },
            { EBC, 'LessThanEconEfficiencyOverTime', { 0.91, 2.0 }},
            { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                AdjacencyCategory = 'FACTORY',
                BuildClose = true,
                BuildStructures = {
                    'T1MetalWorldResource',
                },
                Location = 'LocationType',
            }
        }
    },
}
