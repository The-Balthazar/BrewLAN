do
    local array = {
        Small_Dish_001 = {RadarRadius = 1.518634255, OmniRadius = 1.000000000, EnergyMaintenance = 1.404787711},
          Med_Dish_001 = {RadarRadius = 1.359997609, OmniRadius = 1.215803347, EnergyMaintenance = 1.378464448},
        Small_Dish_002 = {RadarRadius = 1.142902929, OmniRadius = 1.000000000, EnergyMaintenance = 1.118957635},
          Med_Dish_002 = {RadarRadius = 1.162606776, OmniRadius = 1.150430957, EnergyMaintenance = 1.186699167},
        Small_Dish_003 = {RadarRadius = 1.083256195, OmniRadius = 1.000000000, EnergyMaintenance = 1.069351468},
          Med_Dish_003 = {RadarRadius = 1.105310570, OmniRadius = 1.115536972, EnergyMaintenance = 1.127037108},
        Small_Dish_004 = {RadarRadius = 1.058765357, OmniRadius = 1.000000000, EnergyMaintenance = 1.048631459},
          Med_Dish_004 = {RadarRadius = 1.077910018, OmniRadius = 1.093807366, EnergyMaintenance = 1.097398017},
        Xband_Dish = {RadarRadius = 1, OmniRadius = 1, EnergyMaintenance = 1}
    }

    for name, data in array do
        BuffBlueprint {
            Name = name .. '_Buff', DisplayName = name .. '_Buff',
            BuffType = 'PANOPTICONUPGRADE', Stacks = 'ALWAYS', Duration = -1,
            Affects = {
                RadarRadius = {Add = 0, Mult = data.RadarRadius},
                OmniRadius = {Add = 0, Mult = data.OmniRadius},
                EnergyMaintenance = {Add = 0, Mult = data.EnergyMaintenance},
            }
        }
    end
end

BuffBlueprint {
    Name = 'DarknessOmniNerf',
    DisplayName = 'DarknessOmniNerf',
    BuffType = 'OmniRadius',
    Stacks = 'ALWAYS',
    Duration = 20.1,
    Affects = {
        OmniRadius = {
            Add = 0,
            Mult = 0.6,
        },
    },
}
