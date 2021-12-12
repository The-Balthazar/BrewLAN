table.insert(options.ui.items,
    {
        title = "<LOC spawnmenu001>Spawn Menu: Team Columns",
        key = 'spawn_menu_team_columns',
        type = 'slider',
        default = 4,
        custom = {
            min = 1,
            max = 10,
            inc = 1,
        },
    }
)
table.insert(options.ui.items,
    {
        title = "<LOC spawnmenu002>Spawn Menu: Filter Columns",
        key = 'spawn_menu_filter_columns',
        type = 'slider',
        default = 6,
        custom = {
            min = 1,
            max = 15,
            inc = 1,
        },
    }
)
table.insert(options.ui.items,
    {
        title = "<LOC spawnmenu003>Spawn Menu: Split Sources",
        key = 'spawn_menu_split_sources',
        type = 'toggle',
        default = 0,
        custom = {
            states = {
                {text = "<LOC _Off>", key = 0 },
                {text = "<LOC _On>", key = 1 },
            },
        },
    }
)
table.insert(options.ui.items,
    {
        title = "<LOC spawnmenu004>Spawn Menu: Type Filter Mode",
        key = 'spawn_menu_type_filter_mode',
        type = 'toggle',
        default = 0,
        custom = {
            states = {
                {text = "<LOC spawnmenu004phs>Physics Motion Type", key = 0 },
                {text = "<LOC spawnmenu004cat>Blueprint Category", key = 1 },
            },
        },
    }
)
table.insert(options.ui.items,
    {
        title = "<LOC spawnmenu005>Spawn Menu: Include No-tech Filter",
        key = 'spawn_menu_notech_filter',
        type = 'toggle',
        default = 1,
        custom = {
            states = {
                {text = "<LOC _Off>", key = 0 },
                {text = "<LOC _On>", key = 1 },
            },
        },
    }
)
table.insert(options.ui.items,
    {
        title = "<LOC spawnmenu006>Spawn Menu: Include ACU/Paragon Filter",
        key = 'spawn_menu_paragon_filter',
        type = 'toggle',
        default = 0,
        custom = {
            states = {
                {text = "<LOC _Off>", key = 0 },
                {text = "<LOC _On>", key = 1 },
            },
        },
    }
)
table.insert(options.ui.items,
    {
        title = "<LOC spawnmenu007>Spawn Menu: Filter By Menu Sort",
        key = 'spawn_menu_filter_menu_sort',
        type = 'toggle',
        default = 1,
        custom = {
            states = {
                {text = "<LOC _Off>", key = 0 },
                {text = "<LOC _On>", key = 1 },
            },
        },
    }
)
