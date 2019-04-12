BuilderGroup {
    BuilderGroupName = 'EngineerResearchBuilders',
    BuildersType = 'EngineerBuilder',

    Builder {
        BuilderName = 'Engineer Research',
        PlatoonTemplate = 'EngineerBuilderGeneral',
        Priority = 900,
        InstanceCount = 1,
        BuilderConditions = {
            { MIBC, 'RNDResearchIsNotComplete', {} },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2} },
            { LUTL, 'UnitCapCheckLess', { .85 } },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.RESEARCHCENTRE } },
        },
        BuilderType = { 'Commander', 'T1', 'T2', 'T3', 'SubCommander' },
        BuilderData = {
            Construction = {
                NearBasePerimeterPoints = true,
                BaseTemplateFile = '/lua/ai/aibuilders/Loud_MAIN_Base_templates.lua',
                BaseTemplate = 'ResearchLayout',
                ThreatMax = 30,
                BuildStructures = {'T1ResearchCentre'}
            }
        }
    },

    Builder {
        BuilderName = 'Engineer Research Reclaim',
        PlatoonTemplate = 'EngineerStructureReclaimerGeneral',
		PlatoonAddFunctions = { { LUTL, 'NameEngineerUnits'}, },
        Priority = 700,
        BuilderType = { 'T1','T2','T3','Commander' },
        BuilderConditions = {
            { MIBC, 'RNDResearchIsComplete', {} },
			{ LUTL, 'NoBaseAlert', { 'LocationType' }},
        },
        BuilderData = {
			Reclaim = {categories.STRUCTURE * categories.RESEARCHCENTRE},
        },
    },
}
