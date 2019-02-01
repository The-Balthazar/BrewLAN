BuilderGroup {
    BuilderGroupName = 'SorianMetalWorldMassBuilders',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'Sorian MetalWorldMassEngineer',
        PlatoonTemplate = 'EngineerBuilderSorian',
        Priority = 1250,
        BuilderConditions = {
            --{ EBC, 'LessThanEconStorageRatio', { 0.9, 2 } },
            { SIBC, 'LessThanEconEfficiencyOverTime', { 0.91, 2.0}},
            { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            --NumAssistees = 3,
            Construction = {
                AdjacencyCategory = 'FACTORY',
                --AdjacencyDistance = 100,
                BuildClose = true,
                BuildStructures = {
                    'T1MetalWorldResource',
                },
                Location = 'LocationType',
            }
        }
    },
}
