BuilderGroup {
    BuilderGroupName = 'SorianUAST4Shields',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'Sorian UEF Aeon Seraphim T4 Shield Builder',
        PlatoonTemplate = 'T3EngineerBuilderSorian',
        Priority = 900,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 5, categories.ENGINEER * categories.TECH3}},
			{ SIBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH3 } },
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 10, categories.SHIELD * categories.TECH3 * categories.STRUCTURE} },
            { MIBC, 'FactionIndex', {1, 2, 4}},
			{ UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 1, 'SHIELD STRUCTURE EXPERIMENTAL' } },
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2 }},
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
