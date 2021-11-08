version = 3
ScenarioInfo = {
    name = "Mentlegen's Reef",
    description = "<LOC SCMP_005_Description>Once a haven for smugglers, the islands were named after the 'gentlemen' that did business there. Now the islands host a different kind of gentleman, Commanders from the three factions who vie with each other for control of the planet.",
    type = 'skirmish',
    starts = true,
    preview = '',
    size = {2048, 2048},
    map = '/maps/SCMP_005/SCMP_005.scmap',
    save = '/maps/BREW_REEF/BREW_REEF_save.lua',
    script = '/maps/BREW_REEF/BREW_REEF_script.lua',
    norushradius = 450.000000,
    norushoffsetX_ARMY_1 = 39.000000,
    norushoffsetY_ARMY_1 = -163.000000,
    norushoffsetX_ARMY_2 = 0.000000,
    norushoffsetY_ARMY_2 = 177.000000,
    norushoffsetX_ARMY_3 = -170.000000,
    norushoffsetY_ARMY_3 = -50.000000,
    norushoffsetX_ARMY_4 = -128.000000,
    norushoffsetY_ARMY_4 = 110.000000,
    norushoffsetX_ARMY_5 = -79.000000,
    norushoffsetY_ARMY_5 = -163.000000,
    norushoffsetX_ARMY_6 = 148.000000,
    norushoffsetY_ARMY_6 = 130.000000,
    norushoffsetX_ARMY_7 = 170.000000,
    norushoffsetY_ARMY_7 = -50.000000,
    norushoffsetX_ARMY_8 = 20,
    norushoffsetY_ARMY_8 = -36,
    Configurations = {
        ['standard'] = {
            teams = {
                { name = 'FFA', armies = {'ARMY_1','ARMY_2','ARMY_3','ARMY_4','ARMY_5','ARMY_6','ARMY_7','ARMY_8',} },
            },
            customprops = {
                ['ExtraArmies'] = STRING( 'ARMY_9 NEUTRAL_CIVILIAN' ),
            },
        },
    }}
