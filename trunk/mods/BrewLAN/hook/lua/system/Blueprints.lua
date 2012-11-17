#****************************************************************************
#**
#** Hook File: /lua/system/blueprints.lua
#**
#** Modded By: Balthazar
#**
#** Changes: STUFF
#**   
#*********************************************************************
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)
    OldModBlueprints(all_blueprints)
    
    BrewLANFieldEngineerChanges(all_blueprints.Unit)
    BrewLANCybranShieldChanges(all_blueprints.Unit)
    DragBuildQuantumOptics(all_blueprints.Unit)
    ExperimentalStrategicSorting(all_blueprints.Unit)
    SalvationBrewLANChanges(all_blueprints.Unit)
#--    TorpedoBomberWaterLandCat(all_blueprints.Unit)   ##Ends up in them getting shot by subs.
    AeonShieldUpgradeable(all_blueprints.Unit)
#--    HadesUpgradeable(all_blueprints.Unit)  ## That shit was mad crazy OP.
    UnitHidingBrewLAN(all_blueprints.Unit)
    GantryExperimentalBuildOnly(all_blueprints.Unit)

end



# ---------------- Cybran Land factory categories for field engineer(s)



function BrewLANFieldEngineerChanges(all_bps)

    local units_buildcats = {
        urb0101 = 'BUILTBYLANDTIER1FACTORY CYBRAN MOBILE CONSTRUCTION',
        urb0201 = 'BUILTBYLANDTIER2FACTORY CYBRAN MOBILE CONSTRUCTION',
        urb0301 = 'BUILTBYLANDTIER3FACTORY CYBRAN MOBILE CONSTRUCTION',
        uab0101 = 'BUILTBYLANDTIER1FACTORY AEON MOBILE CONSTRUCTION',
        uab0201 = 'BUILTBYLANDTIER2FACTORY AEON MOBILE CONSTRUCTION',
        uab0301 = 'BUILTBYLANDTIER3FACTORY AEON MOBILE CONSTRUCTION',
        xsb0101 = 'BUILTBYLANDTIER1FACTORY SERAPHIM MOBILE CONSTRUCTION',
        xsb0201 = 'BUILTBYLANDTIER2FACTORY SERAPHIM MOBILE CONSTRUCTION',
        xsb0301 = 'BUILTBYLANDTIER3FACTORY SERAPHIM MOBILE CONSTRUCTION',
        xel0209 = 'BUILTBYTIER2FIELD UEF',
    }     

    for unitid, buildcat in units_buildcats do
        if all_bps[unitid] then
            table.insert(all_bps[unitid].Economy.BuildableCategory, buildcat)
        end
    end

end



# ---------------- Cybran Shields


  
function BrewLANCybranShieldChanges(all_bps)   

    local CybranShields = {
        urb4202 = 'TECH1',
        urb4204 = 'TECH1',
        urb4205 = 'TECH2',
        urb4206 = 'TECH3',
        urb4207 = 'TECH3',
    }
    
    for shieldid, cat in CybranShields do
        if all_bps[shieldid] then
            table.removeByValue(all_bps[shieldid].Categories, 'TECH2')
            table.insert(all_bps[shieldid].Categories, cat)
        end
    end
    
    local BuildableCybranShields = {
        urb4202 = 'BUILTBYTIER1ENGINEER',
        urb4205 = 'BUILTBYTIER2ENGINEER',
        urb4206 = 'BUILTBYTIER3ENGINEER',
    }
    for shieldid, cat in BuildableCybranShields do
        if all_bps[shieldid] then
            table.insert(all_bps[shieldid].Categories, cat)
        end
    end
     
    local ED4 = {all_bps['urb4205'],}
    local ED5 = {all_bps['urb4206'],}
    
    for arrayIndex, bp in ED4 do
        table.insert(bp.Categories, 'BUILTBYTIER2COMMANDER')
        table.insert(bp.Categories, 'BUILTBYTIER3COMMANDER')
        table.insert(bp.Categories, 'BUILTBYTIER3ENGINEER')
    end
    for arrayIndex, bp in ED5 do
        table.insert(bp.Categories, 'BUILTBYTIER3COMMANDER')
    end
end 



--[[
function BrewLANCybranShieldChanges(all_bps)   

    local CybranShields = {
        urb4202 = {'TECH1','BUILTBYTIER1ENGINEER',},
        urb4204 = {'TECH1',},
        urb4205 = {'TECH2','BUILTBYTIER2ENGINEER','BUILTBYTIER2COMMANDER',},
        urb4206 = {'TECH3','BUILTBYTIER3ENGINEER','BUILTBYTIER3COMMANDER',},
        urb4207 = {'TECH3',},
    }
    
    for unitid, cats in CybranShields do
        table.removeByValue(bp.Categories, 'TECH2')
        for k, cat in cats do
            table.insert(bp.Categories, cat)
        end
    end
end
--]]


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

    local HidingExperimentals = {
        all_bps['url0401'],
        all_bps['xeb2402'],
    }
        
    for arrayIndex, bp in HidingExperimentals do
        table.removeByValue(bp.Categories, 'BUILTBYTIER3ENGINEER')
        table.removeByValue(bp.Categories, 'BUILTBYTIER3COMMANDER')
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





end