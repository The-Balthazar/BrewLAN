#****************************************************************************
#**
#** Hook File: /lua/system/blueprints.lua
#**
#** Modded By: Balthazar
#**
#** Changes: Various unit category table changes
#**   
#*********************************************************************
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)

    OldModBlueprints(all_blueprints)
    WaterlagBasicAmphib(all_blueprints.Unit)

end



function WaterlagBasicAmphib(all_bps)

    local WaterlagBasicUnits = {
#-=-=-=-=-=-=-=-# T1 Point Defences #-=-=-=-=-=-=-=-#
        all_bps['ueb2101'],
        all_bps['uab2101'],
        all_bps['urb2101'],
        all_bps['xsb2101'],
#-=-=-=-=-=-=-=-# T2 Point Defences #-=-=-=-=-=-=-=-#
        all_bps['ueb2301'],
        all_bps['uab2301'],
        all_bps['urb2301'],
        all_bps['xsb2301'],
#-=-=-=-=-=-=-=-# T3 Point Defences #-=-=-=-=-=-=-=-#
        all_bps['xeb2306'],
	#-=-=-=-#    BrewLAN        #-=-=-=-#
        all_bps['bab2306'],
        all_bps['brb2306'],
        all_bps['bsb2306'],
	#-=-=-=-#    BlackOps       #-=-=-=-#
        all_bps['xab2306'],
        all_bps['xrb2306'],
        all_bps['xsb2306'],
	#-=-=-=-#    4thDimension   #-=-=-=-#
        all_bps['ueb2306'],
        all_bps['uab2306'],
        all_bps['urb2306'],
#-=-=-=-=-=-=-=-# Walls             #-=-=-=-=-=-=-=-#
        all_bps['uab5101'],
        all_bps['ueb5101'],
        all_bps['urb5101'],
        all_bps['xsb5101'],
#-=-=-=-=-=-=-=-# Cybran Shields    #-=-=-=-=-=-=-=-#
        all_bps['urb4202'],
        all_bps['urb4204'],
        all_bps['urb4205'],
        all_bps['urb4206'],
        all_bps['urb4207'],
#-=-=-=-=-=-=-=-# UEF Shields       #-=-=-=-=-=-=-=-#
#        all_bps['beb4102'],
        all_bps['ueb4202'],
        all_bps['ueb4301'],
#-=-=-=-=-=-=-=-# Aeon Shields      #-=-=-=-=-=-=-=-#
#        all_bps['bab4102'],
        all_bps['uab4202'],
        all_bps['uab4301'],
#-=-=-=-=-=-=-=-# Seraphim Shields  #-=-=-=-=-=-=-=-#
        all_bps['bsb4102'],
        all_bps['xsb4202'],
        all_bps['xsb4301'],
    }

    for arrayIndex, bp in WaterlagBasicUnits do

        if not bp.Display.Abilities then bp.Display.Abilities = {} end

        table.insert(bp.Display.Abilities, '<LOC ability_aquatic>Aquatic')

        bp.General.Icon = 'amph'

        bp.Physics.BuildOnLayerCaps.LAYER_Water = true

    end

end

end