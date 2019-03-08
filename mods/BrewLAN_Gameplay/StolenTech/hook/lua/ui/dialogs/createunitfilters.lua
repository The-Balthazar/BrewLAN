Filters = {
    {
        title = 'Search',
        key = 'custominput',
        sortFunc = function(unitID, text)
            local bp = __blueprints[unitID]
            local desc = string.lower(LOC(bp.Description or ''))
            local name = string.lower(LOC(bp.General.UnitName or ''))
            text = string.lower(text)
            return string.find(unitID, text) or string.find(desc, text) or string.find(name, text)
        end,
    },
    {
        title = 'Faction',
        key = 'faction',
        choices = {
            {
                title = 'Aeon',
                key = 'aeon',
                sortFunc = function(unitID)
                    return table.find(__blueprints[unitID].Categories, 'AEON') --string.sub(unitID, 2, 2) == 'a'
                end,
            },
            {
                title = 'UEF',
                key = 'uef',
                sortFunc = function(unitID)
                    return table.find(__blueprints[unitID].Categories, 'UEF') -- string.sub(unitID, 2, 2) == 'e'
                end,
            },
            {
                title = 'Cybran',
                key = 'cybran',
                sortFunc = function(unitID)
                    return table.find(__blueprints[unitID].Categories, 'CYBRAN') -- string.sub(unitID, 2, 2) == 'r'
                end,
            },
            {
                title = 'Seraphim',
                key = 'seraphim',
                sortFunc = function(unitID)
                    return table.find(__blueprints[unitID].Categories, 'SERAPHIM') -- string.sub(unitID, 2, 2) == 's'
                end,
            },
            {
                title = 'Operation',
                key = 'ops',
                sortFunc = function(unitID)
                    return string.sub(unitID, 1, 1) == 'o'
                end,
            },
        },
    },
    {
        title = 'Product',
        key = 'product',
        choices = {
            {
                title = 'SC1',
                key = 'sc1',
                sortFunc = function(unitID)
                    return string.sub(unitID, 1, 1) == 'u'
                end,
            },
            {
                title = 'Download',
                key = 'dl',
                sortFunc = function(unitID)
                    return string.sub(unitID, 1, 1) == 'd'
                end,
            },
            {
                title = 'XPack 1',
                key = 'scx1',
                sortFunc = function(unitID)
                    return string.sub(unitID, 1, 1) == 'x'
                end,
            },
            {
                title = 'BrewLAN',
                key = 'bl',
                sortFunc = function(unitID)
                    return string.sub(unitID, 1, 1) == 's'
                end,
            },
        },
    },
    {
        title = 'Type',
        key = 'type',
        choices = {
            {
                title = 'Land',
                key = 'land',
                sortFunc = function(unitID)
                    local MT = string.lower(__blueprints[unitID].Physics.MotionType or 'no')
                    return (MT == 'ruleumt_amphibious' or MT == 'ruleumt_hover' or (MT == 'ruleumt_amphibiousfloating' and not table.find(__blueprints[unitID].Categories, 'NAVAL')) or MT == 'ruleumt_land') and not (string.sub(unitID, 3, 3) == 'r' or string.sub(unitID, -3, -1) == 'rnd') -- string.sub(unitID, 3, 3) == 'l'
                end,
            },
            {
                title = 'Air',
                key = 'air',
                sortFunc = function(unitID)
                    return string.lower(__blueprints[unitID].Physics.MotionType or 'no') == 'ruleumt_air' -- string.sub(unitID, 3, 3) == 'a'
                end,
            },
            {
                title = 'Naval',
                key = 'naval',
                sortFunc = function(unitID)
                    local MT = string.lower(__blueprints[unitID].Physics.MotionType or 'no')
                    return MT == 'ruleumt_water' or (MT == 'ruleumt_amphibiousfloating' and not table.find(__blueprints[unitID].Categories, 'LAND')) or MT == 'ruleumt_surfacingsub' -- string.sub(unitID, 3, 3) == 's'
                end,
            },
            {
                title = 'Base',
                key = 'base',
                sortFunc = function(unitID)
                    return string.lower(__blueprints[unitID].Physics.MotionType or 'no') == 'ruleumt_none' -- string.sub(unitID, 3, 3) == 'b'
                end,
            },
            {
                title = 'Civilian',
                key = 'civ',
                sortFunc = function(unitID)
                    return string.sub(unitID, 3, 3) == 'c' or not (table.find(__blueprints[unitID].Categories, 'UEF') or table.find(__blueprints[unitID].Categories, 'AEON') or table.find(__blueprints[unitID].Categories, 'CYBRAN') or table.find(__blueprints[unitID].Categories, 'SERAPHIM') )
                end,
            },
            {
                title = 'Research',
                key = 'rnd',
                sortFunc = function(unitID)
                    return string.sub(unitID, 3, 3) == 'r' or string.sub(unitID, -3, -1) == 'rnd'
                end,
            },
        },
    },
    {
        title = 'Tech Level',
        key = 'tech',
        choices = {
            {
                title = 'T1',
                key = 't1',
                sortFunc = function(unitID)
                    return table.find(__blueprints[unitID].Categories, 'TECH1')
                end,
            },
            {
                title = 'T2',
                key = 't2',
                sortFunc = function(unitID)
                    return table.find(__blueprints[unitID].Categories, 'TECH2')
                end,
            },
            {
                title = 'T3',
                key = 't3',
                sortFunc = function(unitID)
                    return table.find(__blueprints[unitID].Categories, 'TECH3')
                end,
            },
            {
                title = 'Exp.',
                key = 't4',
                sortFunc = function(unitID)
                    return table.find(__blueprints[unitID].Categories, 'EXPERIMENTAL')
                end,
            },
        },
    },
}
