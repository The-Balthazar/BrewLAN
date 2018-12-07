BuilderGroup {
    BuilderGroupName = 'T1ShieldsBuilder',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'T1 Shield Builder',
        PlatoonTemplate = 'EngineerBuilder',
        Priority = 950,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 7, categories.SHIELD * categories.STRUCTURE}},
			{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.DEFENSE * categories.TECH1}},
            { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconEfficiency', { 0.6, 1.2 } },
            { UCBC, 'LocationEngineersBuildingLess', { 'LocationType', 1, 'SHIELD STRUCTURE' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 2,
            Construction = {
                AdjacencyCategory = 'ENERGYPRODUCTION, MASSSTORAGE, ENERGYSTORAGE, DEFENSE, MASSEXTRACTION, FACTORY',
                AdjacencyDistance = 60,
                BuildClose = false,
				AvoidCategory = 'SHIELD',
				maxUnits = 1,
				maxRadius = 10,
                BuildStructures = {
                    'T1ShieldDefense',
                },
                Location = 'LocationType',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'CybranT4Shields',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'T4 Shield D Engineer Factory Adj',
        PlatoonTemplate = 'T3EngineerBuilder',
        Priority = 850,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 8, categories.ENGINEER * categories.TECH3}},
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 4, categories.SHIELD * categories.EXPERIMENTAL} },
            { MIBC, 'FactionIndex', {3}},
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

BuilderGroup {
    BuilderGroupName = 'BrewLANShieldUpgrades',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'T1 Shield Upgrade',
        PlatoonTemplate = 'T1Shield',
        Priority = 5,
        InstanceCount = 5,
        BuilderConditions = {
            { EBC, 'GreaterThanEconIncome',  { 5, 150}},
            { MIBC, 'FactionIndex', {1, 2, 4}},
            { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.2 }},
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'T2 Shield Aeon Upgrade',
        PlatoonTemplate = 'T2ShieldAeon',
        Priority = 5,
        InstanceCount = 2,
        BuilderConditions = {
			{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.ENERGYPRODUCTION * categories.TECH3 } },
            { EBC, 'GreaterThanEconIncome',  { 7, 350}},
            { MIBC, 'FactionIndex', {2}},
            { IBC, 'BrainNotLowPowerMode', {} },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.2 }},
        },
        BuilderType = 'Any',
    },
}
