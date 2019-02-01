
BuilderGroup {
    BuilderGroupName = 'Metal World Mass Builders',
    BuildersType = 'EngineerBuilder',

    Builder {
        BuilderName = 'T1 Metal World Template',
        PlatoonTemplate = 'EngineerBuilderGeneral',
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
        --InstanceCount = 1,
        Priority = 900,
		--PriorityFunction = First45Minutes,
        BuilderConditions = {
            { EBC, 'LessThanEconMassStorageRatio', { 95 }},
            { EBC, 'LessThanEconEfficiencyOverTime', { 1.05, 2 }},
            --{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.3, 1.02 }},
            { LUTL, 'UnitCapCheckLess', { .95 } },
			--{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.ENERGYPRODUCTION * categories.STRUCTURE * categories.TECH3 }},
        },
        BuilderType = { 'T1', 'T2' },
        BuilderData = {
            Construction = {
				--NearBasePerimeterPoints = true,
				ThreatMin = -9999,
				ThreatMax = 35,
				BaseTemplateFile = '/lua/ai/aibuilders/Loud_MAIN_Base_templates.lua',
				BaseTemplate = 'MetalWorldLayout',
                BuildStructures = {	'T1MetalWorldResource' },
            }
        }
    }
}
