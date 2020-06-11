AIOpts = {
    {   default = 4,
        label = "<LOC CrystalHill_LOB_Victory>Crystal Hill: Victory Time",
        help = "The minimum amount of time between the first capture of the crystal and declaring a victor.",
        key = 'CrystalVictoryLength',
        pref = 'Crystal_Victory_Length',
        values = {
            {
                text = "60:00",
                help = "60 minutes",
                key = '60',
            },
            {
                text = "45:00",
                help = "45 minutes",
                key = '45',
            },
            {
                text = "30:00",
                help = "30 minutes",
                key = '30',
            },
            {
                text = "20:00",
                help = "20 minutes (Default)",
                key = '20',
            },
            {
                text = "13:45",
                help = "13 minutes 45 seconds",
                key = '13.75',
            },
            {
                text = "5:00",
                help = "5 minutes",
                key = '5',
            },
            {
                text = "2:30",
                help = "2 minutes 30 seconds",
                key = '2.5',
            },
            {
                text = "Overtime",
                help = "Same length as overtime length.",
                key = '0',
            },
        },
    },
    {   default = 6,
        label = "<LOC CrystalHill_LOB_Reset>Crystal Hill: Victory Reset Time",
        help = "The minimum amount of time between any capture of the crystal after the first and declaring a victor.",
        key = 'CrystalResetTime',
        pref = 'Crystal_Reset_Time',
        values = {
            {
                text = "60:00",
                help = "60 minutes",
                key = '60',
            },
            {
                text = "45:00",
                help = "45 minutes",
                key = '45',
            },
            {
                text = "30:00",
                help = "30 minutes",
                key = '30',
            },
            {
                text = "20:00",
                help = "20 minutes",
                key = '20',
            },
            {
                text = "13:45",
                help = "13 minutes 45 seconds",
                key = '13.75',
            },
            {
                text = "5:00",
                help = "5 minutes (Default)",
                key = '5',
            },
            {
                text = "2:30",
                help = "2 minutes 30 seconds",
                key = '2.5',
            },
            {
                text = "1:00",
                help = "1 minutes",
                key = '1',
            },
            {
                text = "Disabled",
                help = "No minimum.",
                key = '0',
            },
        },
    },
    {   default = 5,
        label = "<LOC CrystalHill_LOB_Overtime>Crystal Hill: Victory Overtime",
        help = "The minimum amount of time between an enemy being near the crystal and declaring a victor.",
        key = 'CrystalOvertime',
        pref = 'Crystal_Overtime',
        values = {
            {
                text = "60",
                help = "60 seconds",
                key = '60',
            },
            {
                text = "45",
                help = "45 seconds",
                key = '45',
            },
            {
                text = "30",
                help = "30 seconds",
                key = '30',
            },
            {
                text = "20",
                help = "20 seconds",
                key = '20',
            },
            {
                text = "10",
                help = "10 seconds (Default)",
                key = '10',
            },
            {
                text = "5",
                help = "5 seconds",
                key = '5',
            },
            {
                text = "1",
                help = "1 seconds",
                key = '1',
            },
            {
                text = "Disabled",
                help = "No overtime",
                key = '0',
            },
        },
    },
}
