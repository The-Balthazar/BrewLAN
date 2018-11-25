PlatoonTemplate {
    Name = 'T1Shield',
    Plan = 'UnitUpgradeAI',
    FactionSquads = {
        UEF = {
            { 'seb4102', 0, 1, 'support', 'None' }
        },
        Aeon = {
            { 'sab4102', 0, 1, 'support', 'None' }
        },
        Seraphim = {
            { 'ssb4102', 0, 1, 'support', 'None' }
        },
    },
    GlobalSquads = {
        { categories.seb4102 + categories.sab4102 + categories.ssb4102, 0, 1, 'support', 'None' }
    }
}

PlatoonTemplate {
    Name = 'T2ShieldAeon',
    Plan = 'UnitUpgradeAI',
    FactionSquads = {
        Aeon = {
            { 'uab4202', 0, 1, 'support', 'None' }
        },
    },
    GlobalSquads = {
        { categories.uab4202, 0, 1, 'support', 'None' }
    }
}
