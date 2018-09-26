BuilderGroup {
    BuilderGroupName = 'GantryConstruction',
    BuildersType = 'EngineerBuilder',

    Builder {
        BuilderName = 'Gantry Priority Builder',
        PlatoonTemplate = 'T3EngineerBuilder',
        Priority = 880,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.GANTRY } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.GANTRY } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 7,
            Construction = {
                AdjacencyCategory = 'ENGINEERSTATION',
                AdjacencyDistance = 100,
                BuildClose = false,
                Location = 'LocationType',
                BuildStructures = {
                    'T4Gantry',
                },
            }
        }
    },
    Builder {
        BuilderName = 'Gantry Builder',
        PlatoonTemplate = 'T3EngineerBuilder',
        Priority = 725,
        BuilderConditions = {
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2} },
            { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { UCBC, 'GantryCapCheck', { 'LocationType', 'Gantry' } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 3,
            Construction = {
                AdjacencyCategory = 'ENGINEERSTATION',
                AdjacencyDistance = 100,
                BuildClose = false,
                Location = 'LocationType',
                BuildStructures = {
                    'T4Gantry',
                },
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'GantrySupport',
    BuildersType = 'EngineerBuilder',

    Builder {
        BuilderName = 'Gantry Engineer Builder',
        PlatoonTemplate = 'T3EngineerBuilder',
        Priority = 850,
        BuilderConditions = {
            { UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 0, categories.GANTRY }},
            { MIBC, 'FactionIndex', {1, 3, 4}},
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2} },
            { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 2,
            Construction = {
                AdjacencyCategory = 'GANTRY',
                AdjacencyDistance = 100,
                BuildClose = false,
                Location = 'LocationType',
                BuildStructures = {
                    'T2EngineerSupport',
                    'T2EngineerSupport',
                    'T2EngineerSupport',
                    'T2EngineerSupport',
                    'T2EngineerSupport',
                },
            }
        }
    },
    Builder {
        BuilderName = 'Gantry Shield Support',
        PlatoonTemplate = 'T3EngineerBuilder',
        Priority = 850,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, categories.ENGINEER * categories.TECH3}},
			{ UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 0, categories.GANTRY }},
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 4, categories.SHIELD * categories.STRUCTURE}},
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.1 }},
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 2,
            Construction = {
                AdjacencyCategory = 'GANTRY',
                AdjacencyDistance = 60,
                BuildClose = false,
				AvoidCategory = 'SHIELD',
				maxUnits = 1,
				maxRadius = 10,
                BuildStructures = {
                    'T3ShieldDefense',
                },
                Location = 'LocationType',
            }
        }
    },
}
