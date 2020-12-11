AIOpts = {
    {   default = 1,
        label = "<LOC CityscapesSpawn_LOB>Cityscapes: Player Slots",
        help = "<LOC CityscapesSpawn_LOB_D>Defines which player spawn locations cities can spawn at.",
        key = 'CityscapesSpawn',
        pref = 'Cityscapes_Spawn',
        values = {
            {
                text = "<LOC CityscapesSpawn_LOB_EmptySpots>Empty slots",
                help = "<LOC CityscapesSpawn_LOB_EmptySpotsD>Cities can spawn in empty player spawn locations.",
                key = 'EmptySpots',
            },
            {
                text = "<LOC CityscapesSpawn_LOB_AllSlots>All slots",
                help = "<LOC CityscapesSpawn_LOB_AllSlotsD>Cities can spawn in any player spawn location.",
                key = 'AllSlots',
            },
            {
                text = "<LOC CityscapesSpawn_LOB_OccupiedSlots>Occupied slots",
                help = "<LOC CityscapesSpawn_LOB_OccupiedSlotsD>Cities can spawn around players.",
                key = 'OccupiedSlots',
            },
            {
                text = "<LOC CityscapesSpawn_LOB_false>No Slots",
                help = "<LOC CityscapesSpawn_LOB_falseD>Cities won't spawn at player spawn location.",
                key = 'false',
            },
        },
    },
    {   default = 1,
        label = "<LOC CityscapesTeam_LOB>Cityscapes: Player Slot Team",
        help = "<LOC CityscapesTeam_LOB_D>Defines the owner of cities spawned in occupied slots, if they exist.",
        key = 'CityscapesTeam',
        pref = 'Cityscapes_Team',
        values = {
            {
                text = "<LOC CityscapesTeam_LOB_Civilian>Civilian",
                help = "<LOC CityscapesTeam_LOB_CivilianD>Cities in occupied slots are civilian controlled.",
                key = 'Civilian',
            },
            {
                text = "<LOC CityscapesTeam_LOB_LocalArmy>Local Army",
                help = "<LOC CityscapesTeam_LOB_CivilianD>Cities in occupied slots are controlled by that army.",
                key = 'LocalArmy',
            },
        }
    },
    {   default = 2,
        label = "<LOC CityscapesExpansion_LOB>Cityscapes: Expansion Zones",
        help = "<LOC CityscapesExpansion_LOB_D>Determines if cities spawn at expansion zones markers.",
        key = 'CityscapesExpansion',
        pref = 'Cityscapes_Expansion',
        values = {
            {
                text = "<LOC CityscapesExpansion_LOB_Enabled>Enabled",
                help = "<LOC CityscapesExpansion_LOB_EnabledD>Civilian cities spawn at expansion markers.",
                key = 'Enabled',
            },
            {
                text = "<LOC CityscapesExpansion_LOB_Disabled>Disabled",
                help = "<LOC CityscapesExpansion_LOB_DisabledD>No cities spawn at expansion markers.",
                key = 'Disabled',
            },
        }
    },
    {   default = 1,
        label = "<LOC CityscapesLargeExpansion_LOB>Cityscapes: Large Expansion Zones",
        help = "<LOC CityscapesLargeExpansion_LOB_D>Determines if cities spawn at any large expansion zones markers.",
        key = 'CityscapesLargeExpansion',
        pref = 'Cityscapes_LargeExpansion',
        values = {
            {
                text = "<LOC CityscapesLargeExpansion_LOB_Enabled>Enabled",
                help = "<LOC CityscapesLargeExpansion_LOB_EnabledD>Civilian cities spawn at large expansion markers.",
                key = 'Enabled',
            },
            {
                text = "<LOC CityscapesLargeExpansion_LOB_Disabled>Disabled",
                help = "<LOC CityscapesLargeExpansion_LOB_DisabledD>No cities spawn at large expansion markers.",
                key = 'Disabled',
            },
        }
    },
    {   default = 2,
        label = "<LOC CityscapesObjective_LOB>Cityscapes: Objective Markers",
        help = "<LOC CityscapesObjective_LOB_D>Determines if cities spawn at any Objective markers.",
        key = 'CityscapesObjective',
        pref = 'Cityscapes_Objective',
        values = {
            {
                text = "<LOC CityscapesObjective_LOB_Enabled>Enabled",
                help = "<LOC CityscapesObjective_LOB_EnabledD>Civilian cities spawn at objective markers.",
                key = 'Enabled',
            },
            {
                text = "<LOC CityscapesObjective_LOB_Disabled>Disabled",
                help = "<LOC CityscapesObjective_LOB_DisabledD>No cities spawn at objective markers.",
                key = 'Disabled',
            },
        }
    }
}
