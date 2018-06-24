version = 3 -- Lua Version. Dont touch this
ScenarioInfo = {
    name = "DevTex",
    description = "<LOC BREW_DEV_Description>Everyone loves flat levels. Nice un-lumpy flat levels.",
    preview = '',
    map_version = 1,
    type = 'skirmish',
    starts = true,
    size = {512, 512},
    map = '/maps/BREW_DEV/BREW_DEV.scmap',
    save = '/maps/BREW_DEV/BREW_DEV_save.lua',
    script = '/maps/BREW_DEV/BREW_DEV_script.lua',
    norushradius = 80,
    Configurations = {
        ['standard'] = {
            teams = {
                {
                    name = 'FFA',
                    armies = {'ARMY_1', 'ARMY_2', 'ARMY_3', 'ARMY_4'}
                },
            },
            customprops = {
                ['ExtraArmies'] = STRING( 'ARMY_9 NEUTRAL_CIVILIAN' ),
            },
        },
    },
}
