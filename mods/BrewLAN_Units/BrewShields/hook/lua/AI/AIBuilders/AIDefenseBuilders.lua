BuilderGroup {
    BuilderGroupName = 'UAST4Shields',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'UEF Aeon Seraphim T4 Shield',
        PlatoonTemplate = 'T3EngineerBuilder',
        Priority = 850,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 8, categories.ENGINEER * categories.TECH3}},
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 4, categories.SHIELD * categories.EXPERIMENTAL} },
            { MIBC, 'FactionIndex', {1, 2, 4}},
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.4 }},
            { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 3,
            Construction = {
                AdjacencyCategory = 'GANTRY, FACTORY TECH3, FACTORY EXPERIMENTAL, STRUCTURE EXPERIMENTAL, ENERGYPRODUCTION TECH3',
                AdjacencyDistance = 100,
                BuildClose = false,
                BuildStructures = {
                    'T4ShieldDefense',
                },
                Location = 'LocationType',
            }
        }
    },
}
