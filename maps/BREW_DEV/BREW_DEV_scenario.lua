version = 3
ScenarioInfo = {
    name = 'DevTex',
    description = '<LOC BREW_DEV_Description>Everyone loves flat levels. Nice un-lumpy flat levels.',
    type = 'skirmish',
    starts = true,
    preview = '',
    size = {512, 512},
    map = '/maps/BREW_DEV/BREW_DEV.scmap',
    save = '/maps/BREW_DEV/BREW_DEV_save.lua',
    script = '/maps/BREW_DEV/BREW_DEV_script.lua',
    norushradius = 80.000000,
    norushoffsetX_ARMY_1 = 0.000000,
    norushoffsetY_ARMY_1 = 0.000000,
    norushoffsetX_ARMY_2 = 0.000000,
    norushoffsetY_ARMY_2 = 0.000000,
    norushoffsetX_ARMY_3 = 0.000000,
    norushoffsetY_ARMY_3 = 0.000000,
    norushoffsetX_ARMY_4 = 0.000000,
    norushoffsetY_ARMY_4 = 0.000000,
    Configurations = {
        ['standard'] = {
            teams = {
                { name = 'FFA', armies = {'ARMY_1','ARMY_2','ARMY_3','ARMY_4',} },
            },
            customprops = {
                ['ExtraArmies'] = STRING( 'ARMY_9 NEUTRAL_CIVILIAN' ),
            },
        },
    }}
