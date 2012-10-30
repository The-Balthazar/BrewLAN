#****************************************************************************
#**
#** Hook File: /lua/system/blueprints.lua
#**
#** Modded By: Balthazar
#**
#** Changes: Various unit changes
#**   
#*********************************************************************
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)

    OldModBlueprints(all_blueprints)
    DragBuildQuantumOptics(all_blueprints.Unit)
    ExperimentalStrategicSorting(all_blueprints.Unit)
    SalvationBrewLANChanges(all_blueprints.Unit)
    ED1BrewLANChanges(all_blueprints.Unit)
    ED2BrewLANChanges(all_blueprints.Unit)
    ED3BrewLANChanges(all_blueprints.Unit)
    ED4BrewLANChanges(all_blueprints.Unit)
    ED4and5BrewLANChanges(all_blueprints.Unit)
    CybranBUILTBYLANDCat(all_blueprints.Unit)
#--    TorpedoBomberWaterLandCat(all_blueprints.Unit)   ##Ends up in them getting shot by subs.
    AeonShieldUpgradeable(all_blueprints.Unit)
#--    HadesUpgradeable(all_blueprints.Unit)  ## That shit was mad crazy OP.
    UnitHidingBrewLAN(all_blueprints.Unit)
    GantryExperimentalBuildOnly(all_blueprints.Unit)

end



# ---------------- Cybran Land factory categories for field engineer(s)



function CybranBUILTBYLANDCat(all_bps)

#    local cybrant1landfactory = {
#        all_bps['urb0101'],
#    }
#    for arrayIndex, bp in cybrant1landfactory do
#        table.insert(bp.Economy.BuildableCategory, 'BUILTBYLANDTIER1FACTORY CYBRAN MOBILE CONSTRUCTION')
#    end


    local cybrant2landfactory = {
         all_bps['urb0201'],
    } 
    for arrayIndex, bp in cybrant2landfactory do
        table.insert(bp.Economy.BuildableCategory, 'BUILTBYLANDTIER2FACTORY CYBRAN MOBILE CONSTRUCTION')
    end     
      
    local aeont2landfactory = {
         all_bps['uab0201'],
    }
    for arrayIndex, bp in aeont2landfactory do
        table.insert(bp.Economy.BuildableCategory, 'BUILTBYLANDTIER2FACTORY AEON MOBILE CONSTRUCTION')
    end  

    local cybrant3landfactory = {
         all_bps['urb0301'],
    } 
    
    for arrayIndex, bp in cybrant3landfactory do
        table.insert(bp.Economy.BuildableCategory, 'BUILTBYLANDTIER3FACTORY CYBRAN MOBILE CONSTRUCTION')
    end
     
    local aeont3landfactory = {
         all_bps['uab0301'],
    } 
    for arrayIndex, bp in aeont3landfactory do
        table.insert(bp.Economy.BuildableCategory, 'BUILTBYLANDTIER3FACTORY AEON MOBILE CONSTRUCTION')
    end
          


    local SparkyComeHereYou = {
        all_bps['xel0209'],
    }
    for arrayIndex, bp in SparkyComeHereYou do
        table.insert(bp.Economy.BuildableCategory, 'BUILTBYTIER2FIELD UEF')
    end



end



# ---------------- Quantum optics



function DragBuildQuantumOptics(all_bps)

    local quantumoptics = {
        all_bps['xab3301'],
    }
    for arrayIndex, bp in quantumoptics do
        table.insert(bp.Categories, 'DRAGBUILD')
    end
end



# ---------------- Experimental



function ExperimentalStrategicSorting(all_bps)

    local t4buildings = {
        all_bps['xab1401'], #Paragon
        all_bps['ueb2401'], #Mavor
    }
    for arrayIndex, bp in t4buildings do
        table.insert(bp.Categories, 'SORTSTRATEGIC')
    end
end

function SalvationBrewLANChanges(all_bps)

    local AeonSalvation = {
        all_bps['xab2307'],
    }
    for arrayIndex, bp in AeonSalvation do
        table.remove(bp.Categories, 8)
        table.insert(bp.Categories, 'EXPERIMENTAL')

        if not bp.Display.AINames then bp.Display.AINames = {} end
        table.insert(bp.Display.AINames, 'Judgment')
        table.insert(bp.Display.AINames, 'Reconciliation')
        table.insert(bp.Display.AINames, 'Purgatory')
        table.insert(bp.Display.AINames, 'Avatar')
        table.insert(bp.Display.AINames, 'Spitter')
        table.insert(bp.Display.AINames, 'Grassy Knoll')
        table.insert(bp.Display.AINames, 'Giant Phallus Cannon')
    end
end

function UnitHidingBrewLAN(all_bps)

    local CybranScathis = {
        all_bps['url0401'],
    }
    local UEFNovax = {
        all_bps['xeb2402'],
    }
    for arrayIndex, bp in CybranScathis do
        table.remove(bp.Categories, 4)
        table.remove(bp.Categories, 3)
    end
    for arrayIndex, bp in UEFNovax do
        table.remove(bp.Categories, 5)
        table.remove(bp.Categories, 4)
    end
end

# ---------------- Cybran Shields



function ED1BrewLANChanges(all_bps)

    local ED1ShieldGen = {
        all_bps['urb4202'],
    }
    for arrayIndex, bp in ED1ShieldGen do
        table.remove(bp.Categories, 10)
        table.insert(bp.Categories, 'TECH1')
        table.insert(bp.Categories, 'BUILTBYTIER1ENGINEER')
    end
end

function ED2BrewLANChanges(all_bps)

    local ED2ShieldGen = {
        all_bps['urb4204'],
    }
    for arrayIndex, bp in ED2ShieldGen do
        table.remove(bp.Categories, 6)
        table.insert(bp.Categories, 'TECH1')
    end
end

function ED3BrewLANChanges(all_bps)

    local ED3ShieldGen = {
        all_bps['urb4205'],
    }
    for arrayIndex, bp in ED3ShieldGen do
        table.insert(bp.Categories, 'BUILTBYTIER2ENGINEER')
        table.insert(bp.Categories, 'BUILTBYTIER3ENGINEER')
        table.insert(bp.Categories, 'BUILTBYTIER2COMMANDER')
        table.insert(bp.Categories, 'BUILTBYTIER3COMMANDER')
    end
end

function ED4BrewLANChanges(all_bps)

    local ED4ShieldGen = {
        all_bps['urb4206'],
    }
    for arrayIndex, bp in ED4ShieldGen do
        table.insert(bp.Categories, 'BUILTBYTIER3ENGINEER')
        table.insert(bp.Categories, 'BUILTBYTIER3COMMANDER')
    end
end

function ED4and5BrewLANChanges(all_bps)

    local ED45ShieldGen = {
        all_bps['urb4206'],
        all_bps['urb4207'],
    }
    for arrayIndex, bp in ED45ShieldGen do
        table.remove(bp.Categories, 6)
        table.insert(bp.Categories, 'TECH3')
    end
end



# ---------------- 



function AeonShieldUpgradeable(all_bps)

    local AeonT2Shield = {
        all_bps['uab4202'],
    }
    for arrayIndex, bp in AeonT2Shield do
        table.insert(bp.Categories, 'SHOWQUEUE')
        table.insert(bp.Display.Abilities, '<LOC ability_upgradable>Upgradeable')
        table.insert(bp.Economy.RebuildBonusIds, 'uab4301')

        if not bp.Economy.BuildableCategory then bp.Economy.BuildableCategory = {} end
        table.insert(bp.Economy.BuildableCategory, 'uab4301')
    end
end



# ---------------- 



function HadesUpgradeable(all_bps)

    local CybranHades = {
        all_bps['urb2301'],
    }
    for arrayIndex, bp in CybranHades do
        table.insert(bp.Categories, 'SHOWQUEUE')

        if not bp.Display.Abilities then bp.Display.Abilities = {} end
        table.insert(bp.Display.Abilities, '<LOC ability_upgradable>Upgradeable')

        if not bp.Economy.RebuildBonusIds then bp.Economy.RebuildBonusIds = {} end
        table.insert(bp.Economy.RebuildBonusIds, 'brb2306')

        if not bp.Economy.BuildableCategory then bp.Economy.BuildableCategory = {} end
        table.insert(bp.Economy.BuildableCategory, 'brb2306')
    end
end



# ---------------- Torpedo bomber cat so they land on water.



function TorpedoBomberWaterLandCat(all_bps)

    local TorpedoBombers = {
	all_bps['bra0307'], #T3 Cybran
	all_bps['bea0307'], #T3 UEF
	all_bps['bsa0307'], #T3 Seraphim
	all_bps['xaa0306'], #T3 Aeon

	all_bps['ura0204'], #T2 Cybran
	all_bps['uea0204'], #T2 UEF
	all_bps['xsa0204'], #T2 Seraphim
	all_bps['uaa0204'], #T2 Aeon

	all_bps['bra0106'], #T1 Cybran
	all_bps['bea0106'], #T1 UEF
	all_bps['bsa0106'], #T1 Seraphim
	all_bps['baa0106'], #T1 Aeon
    }
    for arrayIndex, bp in TorpedoBombers do
        table.insert(bp.Categories, 'TRANSPORTATION')
    end	

end



# ---------------- Moving the Fatboy into the Gantry.



function GantryExperimentalBuildOnly(all_bps)

    local UEFExperimentals = {
	all_bps['uel0401'],
    }

    for arrayIndex, bp in UEFExperimentals do
    	table.removeByValue(bp.Categories, 'BUILTBYTIER3ENGINEER')
    	table.removeByValue(bp.Categories, 'BUILTBYTIER3COMMANDER')
    	table.removeByValue(bp.Categories, 'DRAGBUILD')
    	table.removeByValue(bp.Categories, 'NEEDMOBILEBUILD')
        table.insert(bp.Categories, 'BUILTBYGANTRY')
    end	
end




end