--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints
local BrewLANPath = function()
    for i, mod in __active_mods do
        --UID also hard referenced in /hook/lua/game.lua and mod_info.lua and in paragongame blueprints
        if mod.uid == "25D57D85-7D84-27HT-A501-BR3WL4N000079" then
            return mod.location
        end
    end
end

function ModBlueprints(all_blueprints)         
    OldModBlueprints(all_blueprints)
    
    BrewLANBuildCatChanges(all_blueprints.Unit)
    BrewLANCategoryChanges(all_blueprints.Unit)
    BrewLANGantryBuildList(all_blueprints.Unit)
    BrewLANHeavyWallBuildList(all_blueprints.Unit)
    --BrewLANNameCalling(all_blueprints.Unit)
    UpgradeableToBrewLAN(all_blueprints.Unit)
    TorpedoBomberWaterLandCat(all_blueprints.Unit)
    RoundGalacticCollosusHealth(all_blueprints.Unit)
    BrewLANMatchBalancing(all_blueprints.Unit)
    BrewLANNavalShields(all_blueprints.Unit)
    BrewLANBomberDamageType(all_blueprints.Unit)
    BrewLANNavalEngineerCatFixes(all_blueprints.Unit)
    BrewLANRelativisticLinksUpdate(all_blueprints)
    BrewLANMegalithEggs(all_blueprints.Unit)
    ExtractFrozenMeshBlueprint(all_blueprints.Unit)
end

--------------------------------------------------------------------------------
-- Additional buildable categories
--------------------------------------------------------------------------------

function BrewLANBuildCatChanges(all_bps)
    local units_buildcats = {
        urb0101 = {'BUILTBYLANDTIER1FACTORY CYBRAN MOBILE CONSTRUCTION',},
        urb0201 = {'BUILTBYLANDTIER2FACTORY CYBRAN MOBILE CONSTRUCTION',},
        urb0301 = {'BUILTBYLANDTIER3FACTORY CYBRAN MOBILE CONSTRUCTION',},
        uab0101 = {'BUILTBYLANDTIER1FACTORY AEON MOBILE CONSTRUCTION',},
        uab0201 = {'BUILTBYLANDTIER2FACTORY AEON MOBILE CONSTRUCTION',},
        uab0301 = {'BUILTBYLANDTIER3FACTORY AEON MOBILE CONSTRUCTION',},
        xsb0101 = {'BUILTBYLANDTIER1FACTORY SERAPHIM MOBILE CONSTRUCTION',},
        xsb0201 = {'BUILTBYLANDTIER2FACTORY SERAPHIM MOBILE CONSTRUCTION',},
        xsb0301 = {'BUILTBYLANDTIER3FACTORY SERAPHIM MOBILE CONSTRUCTION',},  
        ueb0101 = {'BUILTBYLANDTIER1FACTORY UEF MOBILE CONSTRUCTION',},
        ueb0301 = {'BUILTBYLANDTIER3FACTORY UEF MOBILE CONSTRUCTION',},
        uel0401 = {'BUILTBYLANDTIER3FACTORY UEF MOBILE CONSTRUCTION',},
        --TeaD tiny factories
        teb0101 = {'BUILTBYLANDTIER1FACTORY UEF MOBILE CONSTRUCTION',},
        trb0101 = {'BUILTBYLANDTIER1FACTORY CYBRAN MOBILE CONSTRUCTION',},
        tab0101 = {'BUILTBYLANDTIER1FACTORY AEON MOBILE CONSTRUCTION',},
        tsb0101 = {'BUILTBYLANDTIER1FACTORY SERAPHIM MOBILE CONSTRUCTION',},
        --FAF support factories
        zab9501 = {'BUILTBYLANDTIER2FACTORY AEON MOBILE CONSTRUCTION',},
        zab9601 = {'BUILTBYLANDTIER3FACTORY AEON MOBILE CONSTRUCTION',},
        zeb9501 = {'BUILTBYLANDTIER2FACTORY UEF MOBILE CONSTRUCTION',},
        zeb9601 = {'BUILTBYLANDTIER3FACTORY UEF MOBILE CONSTRUCTION',},
        zrb9501 = {'BUILTBYLANDTIER2FACTORY CYBRAN MOBILE CONSTRUCTION',},
        zrb9601 = {'BUILTBYLANDTIER3FACTORY CYBRAN MOBILE CONSTRUCTION',},
        zsb9501 = {'BUILTBYLANDTIER2FACTORY SERAPHIM MOBILE CONSTRUCTION',},
        zsb9601 = {'BUILTBYLANDTIER3FACTORY SERAPHIM MOBILE CONSTRUCTION',},
        --Tech 1 Field Engineers
        sel0119 = {'BUILTBYTIER1ENGINEER UEF COUNTERINTELLIGENCE','BUILTBYTIER1ENGINEER UEF AIRSTAGINGPLATFORM',},
        srl0119 = {'BUILTBYTIER1ENGINEER CYBRAN COUNTERINTELLIGENCE','BUILTBYTIER1ENGINEER CYBRAN AIRSTAGINGPLATFORM',},
        ssl0119 = {'BUILTBYTIER1ENGINEER SERAPHIM COUNTERINTELLIGENCE','BUILTBYTIER1ENGINEER SERAPHIM AIRSTAGINGPLATFORM',},
        sal0119 = {'BUILTBYTIER1ENGINEER AEON COUNTERINTELLIGENCE','BUILTBYTIER1ENGINEER AEON AIRSTAGINGPLATFORM',},
        --Tech 2 Field Engineers
        srl0209 = {'BUILTBYTIER2ENGINEER CYBRAN COUNTERINTELLIGENCE','BUILTBYTIER2ENGINEER CYBRAN AIRSTAGINGPLATFORM',},
        ssl0219 = {'BUILTBYTIER2ENGINEER SERAPHIM COUNTERINTELLIGENCE','BUILTBYTIER2ENGINEER SERAPHIM AIRSTAGINGPLATFORM',},
        xel0209 = {'BUILTBYTIER2ENGINEER UEF COUNTERINTELLIGENCE','BUILTBYTIER2ENGINEER UEF AIRSTAGINGPLATFORM','BUILTBYTIER2FIELD UEF',}, 
        sal0209 = {'BUILTBYTIER2ENGINEER AEON COUNTERINTELLIGENCE','BUILTBYTIER2ENGINEER AEON AIRSTAGINGPLATFORM',},
        --Tech 3 Field Engineers
        sel0319 = {'BUILTBYTIER3ENGINEER UEF COUNTERINTELLIGENCE','BUILTBYTIER3ENGINEER UEF AIRSTAGINGPLATFORM',},
        srl0319 = {'BUILTBYTIER3ENGINEER CYBRAN COUNTERINTELLIGENCE','BUILTBYTIER3ENGINEER CYBRAN AIRSTAGINGPLATFORM',},
        ssl0319 = {'BUILTBYTIER3ENGINEER SERAPHIM COUNTERINTELLIGENCE','BUILTBYTIER3ENGINEER SERAPHIM AIRSTAGINGPLATFORM',},
        sal0319 = {'BUILTBYTIER3ENGINEER AEON COUNTERINTELLIGENCE','BUILTBYTIER3ENGINEER AEON AIRSTAGINGPLATFORM',},
        --These categories are restricted if controlled by a human in the hooked unit scripts
        ual0105 = {'BUILTBYTIER1FIELD AEON',},
        ual0208 = {'BUILTBYTIER2FIELD AEON',},
        ual0309 = {'BUILTBYTIER3FIELD AEON',},
        uel0105 = {'BUILTBYTIER1FIELD UEF',},
        uel0208 = {'BUILTBYTIER2FIELD UEF',},
        uel0309 = {'BUILTBYTIER3FIELD UEF',},
        url0105 = {'BUILTBYTIER1FIELD CYBRAN',},
        url0208 = {'BUILTBYTIER2FIELD CYBRAN',},
        url0309 = {'BUILTBYTIER3FIELD CYBRAN',},
        xsl0105 = {'BUILTBYTIER1FIELD SERAPHIM',},
        xsl0208 = {'BUILTBYTIER2FIELD SERAPHIM',},
        xsl0309 = {'BUILTBYTIER3FIELD SERAPHIM',},    
        --Support Commanders                                           
        ual0301 = {'BUILTBYTIER3FIELD AEON',},    
        uel0301 = {'BUILTBYTIER3FIELD UEF',},
        url0301 = {'BUILTBYTIER3FIELD CYBRAN',},
        xsl0301 = {'BUILTBYTIER3FIELD SERAPHIM',},
    }
    for unitid, buildcat in units_buildcats do
        if all_bps[unitid] and all_bps[unitid].Economy.BuildableCategory then   --Xtreme Wars crash fix here. They removed the Fatboys ability to build.
            for i in buildcat do
                table.insert(all_bps[unitid].Economy.BuildableCategory, buildcat[i])
            end
        end
    end  
end

--------------------------------------------------------------------------------
-- Fixes for land-built factories being able to build non-land engineers non-specifically.
--------------------------------------------------------------------------------

function BrewLANNavalEngineerCatFixes(all_bps)
    local cats_table = {
        {'BUILTBYTIER3FACTORY UEF MOBILE CONSTRUCTION',      'BUILTBYTIER3FACTORY UEF MOBILE LAND CONSTRUCTION'},
        {'BUILTBYTIER3FACTORY CYBRAN MOBILE CONSTRUCTION',   'BUILTBYTIER3FACTORY CYBRAN MOBILE LAND CONSTRUCTION'},
        {'BUILTBYTIER3FACTORY AEON MOBILE CONSTRUCTION',     'BUILTBYTIER3FACTORY AEON MOBILE LAND CONSTRUCTION'},
        {'BUILTBYTIER3FACTORY SERAPHIM MOBILE CONSTRUCTION', 'BUILTBYTIER3FACTORY SERAPHIM MOBILE LAND CONSTRUCTION'},
        {'BUILTBYTIER2FACTORY UEF MOBILE CONSTRUCTION',      'BUILTBYTIER2FACTORY UEF MOBILE LAND CONSTRUCTION'},
        {'BUILTBYTIER2FACTORY CYBRAN MOBILE CONSTRUCTION',   'BUILTBYTIER2FACTORY CYBRAN MOBILE LAND CONSTRUCTION'},
        {'BUILTBYTIER2FACTORY AEON MOBILE CONSTRUCTION',     'BUILTBYTIER2FACTORY AEON MOBILE LAND CONSTRUCTION'},
        {'BUILTBYTIER2FACTORY SERAPHIM MOBILE CONSTRUCTION', 'BUILTBYTIER2FACTORY SERAPHIM MOBILE LAND CONSTRUCTION'},
        {'BUILTBYTIER1FACTORY UEF MOBILE CONSTRUCTION',      'BUILTBYTIER1FACTORY UEF MOBILE LAND CONSTRUCTION'},
        {'BUILTBYTIER1FACTORY CYBRAN MOBILE CONSTRUCTION',   'BUILTBYTIER1FACTORY CYBRAN MOBILE LAND CONSTRUCTION'},
        {'BUILTBYTIER1FACTORY AEON MOBILE CONSTRUCTION',     'BUILTBYTIER1FACTORY AEON MOBILE LAND CONSTRUCTION'},
        {'BUILTBYTIER1FACTORY SERAPHIM MOBILE CONSTRUCTION', 'BUILTBYTIER1FACTORY SERAPHIM MOBILE LAND CONSTRUCTION'},
    }
    
    for id, bp in all_bps do
        if bp.General.Classification == 'RULEUC_Factory' and bp.Physics.BuildOnLayerCaps.LAYER_Water == false then
            if bp.Economy.BuildableCategory then
                for i, cat in bp.Economy.BuildableCategory do
                    for index, cattable in cats_table do
                        if cat == cattable[1] then
                            bp.Economy.BuildableCategory[i] = cattable[2]
                        end
                    end
                end
            end
        end
    end
end   
   
--------------------------------------------------------------------------------
-- Unit category changes
--------------------------------------------------------------------------------
   
function BrewLANCategoryChanges(all_bps) 
    local Units = {
        --Cybran Shields
        urb4202 = {'TECH1','BUILTBYTIER1ENGINEER','BUILTBYTIER2ENGINEER','BUILTBYTIER2COMMANDER','BUILTBYTIER3ENGINEER','BUILTBYTIER3COMMANDER', r = 'TECH2', },
        urb4204 = {'TECH1', r = 'TECH2', },
        urb4205 = {'BUILTBYTIER2ENGINEER','BUILTBYTIER2COMMANDER','BUILTBYTIER3ENGINEER','BUILTBYTIER3COMMANDER',},
        urb4206 = {'TECH3','BUILTBYTIER3ENGINEER','BUILTBYTIER3COMMANDER', r = 'TECH2', },
        urb4207 = {'TECH3','BUILTBYTIER3FIELD', r = 'TECH2', },
        --Tech 3 units
        xab3301 = {'DRAGBUILD', 'SIZE16', r = 'SIZE4', },--Aeon Quantum Optics
        xeb2306 = {'SIZE4', r = 'SIZE12', },---------------Ravager       
        xeb0204 = {'BUILTBYTIER3ENGINEER','BUILTBYTIER3COMMANDER','DRAGBUILD', },--Kennel 
        xrb0304 = {'BUILTBYTIER3ENGINEER','BUILTBYTIER3COMMANDER','DRAGBUILD','TECH3', r = 'TECH2' },--Hive
        
        xrl0004 = {'TECH3', r = 'TECH2'},
        
        --Experimental units
        xab1401 = {'SORTECONOMY',},----------------------------Paragon
        ueb2401 = {'SORTSTRATEGIC',}, -------------------------Mavor
        xab2307 = {'EXPERIMENTAL', r = 'TECH3', },-------------Salvation
        url0401 = {NoBuild = true, }, -------------------------Scathis
        xeb2402 = {NoBuild = true, },--------------------------Noxav Defence Satelite Uplink
    }
    local buildcats = {  
        'BUILTBYTIER1ENGINEER',
        'BUILTBYTIER1COMMANDER',
        'BUILTBYTIER1FIELD',
        'BUILTBYTIER2ENGINEER',
        'BUILTBYTIER2COMMANDER',
        'BUILTBYTIER2FIELD',
        'BUILTBYTIER3ENGINEER',
        'BUILTBYTIER3COMMANDER',  
        'BUILTBYTIER3FIELD',  
        'BUILTBYGANTRY',
        'BUILTBYHEAVYWALL',
    }
    for k, v in Units do   
        if all_bps[k] then
            if not v.NoBuild then
                for i in v do
                    if i == 'r' then
                        if type(v.r) == 'string' then  
                            table.removeByValue(all_bps[k].Categories, v.r)
                        elseif type(v.r) == 'table' then   
                            for i in v.r do
                                table.removeByValue(all_bps[k].Categories, v.r[i])
                            end
                        end
                    end
                    if i != 'r' then
                        table.insert(all_bps[k].Categories, v[i])
                    end
                end
            else
                for i in buildcats do
                    table.removeByValue(all_bps[k].Categories, buildcats[i])
                end 
            end
        end
    end
end   
 
--------------------------------------------------------------------------------
-- Allowing other experimentals that look like they fit to be gantry buildable
--------------------------------------------------------------------------------

function BrewLANGantryBuildList(all_bps)
    for id, bp in all_bps do
        --Check the Gantry can't already build it, and that its a mobile experimental
        if table.find(bp.Categories, 'BUILTBYGANTRY') and table.find(bp.Categories, 'EXPERIMENTAL') then
            --Populate the Gantry AI table
            if table.find(bp.Categories, 'AIR') then
                table.insert(all_bps.seb0401.AI.Experimentals.Air, {id})
            else
                table.insert(all_bps.seb0401.AI.Experimentals.Other, {id})
            end
        elseif --table.find(bp.Categories, 'MOBILE')
        --and table.find(bp.Categories, 'EXPERIMENTAL') or
        table.find(bp.Categories, 'NEEDMOBILEBUILD') 
        then
            --Check it should actually be buildable
            if table.find(bp.Categories, 'BUILTBYTIER1COMMANDER')
            or table.find(bp.Categories, 'BUILTBYTIER1ENGINEER')
            or table.find(bp.Categories, 'BUILTBYTIER2COMMANDER')
            or table.find(bp.Categories, 'BUILTBYTIER2ENGINEER')   
            or table.find(bp.Categories, 'BUILTBYTIER3COMMANDER')
            or table.find(bp.Categories, 'BUILTBYTIER3ENGINEER')
            --For BlOps, they have this as a thing.
            or table.find(bp.Categories, 'BUILTBYTIER4COMMANDER')
            or table.find(bp.Categories, 'BUILTBYTIER4ENGINEER')
            then
                --Check it wouldn't be bigger than the Gantry hole
                if bp.Physics.SkirtSizeX < 13
                or not bp.Physics.SkirtSizeX
                --or bp.Footprint.SizeX < 9
                then
                    table.insert(bp.Categories, 'BUILTBYGANTRY')
                    --Populate the Gantry AI table with the newly selected experimentals, so AI use them.
                    if table.find(bp.Categories, 'AIR') and table.find(bp.Categories, 'EXPERIMENTAL') then
                        table.insert(all_bps.seb0401.AI.Experimentals.Air, {id})
                    elseif table.find(bp.Categories, 'EXPERIMENTAL') then
                        table.insert(all_bps.seb0401.AI.Experimentals.Other, {id})
                    end
                end
            end 
        end
    end
end
  
--------------------------------------------------------------------------------
-- Propperly choosing what should be buildable by the heavy walls.
--------------------------------------------------------------------------------

function BrewLANHeavyWallBuildList(all_bps)
    for id, bp in all_bps do
        --Check its not hard coded to be buildable, then check it meets the standard requirements.
        if not table.find(bp.Categories, 'BUILTBYHEAVYWALL')
        and table.find(bp.Categories, 'STRUCTURE')
        then
            if table.find(bp.Categories, 'BUILTBYTIER1ENGINEER')
            or table.find(bp.Categories, 'BUILTBYTIER2ENGINEER')
            or table.find(bp.Categories, 'BUILTBYTIER3ENGINEER')
            then
                if table.find(bp.Categories, 'DEFENSE') or table.find(bp.Categories, 'INDIRECTFIRE') then
                    --Check it wouldn't overlap badly with the wall
                    local fits = { X = false, Z = false,}
                    local correct = { X = false, Z = false,}   
                    
                    if bp.Footprint.SizeX == 3 and bp.Physics.SkirtSizeX == 3 or bp.Footprint.SizeX == 3 and bp.Physics.SkirtSizeX == 0 then   
                        correct.X = true
                        fits.X = true
                    elseif bp.Physics.SkirtSizeX < 3 and bp.Footprint.SizeX < 3 then
                        fits.X = true
                    end
                    
                    if bp.Footprint.SizeZ == 3 and bp.Physics.SkirtSizeZ == 3 or bp.Footprint.SizeZ == 3 and bp.Physics.SkirtSizeZ == 0 then   
                        correct.Z = true
                        fits.Z = true       
                    elseif bp.Physics.SkirtSizeZ < 3 and bp.Footprint.SizeZ < 3 then
                        fits.Z = true
                    end
                    
                    if fits.X and fits.Z then   
                        table.insert(bp.Categories, 'BUILTBYHEAVYWALL')
                        --This is to prevent it from having the same footprint as the wall
                        --and from it removing all the path blocking of the wall if it dies or gets removed.
                        --It will still remove the blocking from the center of the wall, but that's acceptable.
                        
                        --This will also make it so those turrets will no longer block pathing whilst adjacent
                        --But that is probably fine. 
                        if correct.X then                               
                            bp.Footprint.SizeX = 1
                            bp.Physics.SkirtOffsetX = -1
                            bp.Physics.SkirtSizeX = 3  
                        end 
                        if correct.Z then                               
                            bp.Footprint.SizeZ = 1
                            bp.Physics.SkirtOffsetZ = -1   
                            bp.Physics.SkirtSizeZ = 3  
                        end
                    end    
                end
            end
        end
    end
end
 
--------------------------------------------------------------------------------
-- This has no effect, and as a result is no longer ran
--------------------------------------------------------------------------------
  
function BrewLANNameCalling(all_bps)
    local Units = {
        --Salvation
        xab2307 = {'Judgment', 'Reconciliation', 'Purgatory', 'Avatar', 'Spitter', 'Grassy Knoll', 'Giant Phallus Cannon', },
    }
    for k, v in Units do   
        if all_bps[k] then
            for i in v do  
                if not all_bps[k].Display.AINames then all_bps[k].Display.AINames = {} end
                table.insert(all_bps[k].Display.AINames, v[i])
            end 
        end
    end
end
  
--------------------------------------------------------------------------------
-- Specifying units to be upgradable into eachother
--------------------------------------------------------------------------------
  
function UpgradeableToBrewLAN(all_bps)
    local VanillasToUpgrade = {
        uab4202 = 'uab4301',--FromAeon T2 shield
        xsb3202 = 'sss0305',--From Seraphim T2 sonar
        --urb2301 = 'srb0306',--From Cybran T2 PD Cerberus to Hades. A little OP.
        urb1301 = 'srb1311',--To Cloakable Generator 
        urb1302 = 'srb1312',--To Cloakable Extractor
        urb1303 = 'srb1313',--To Cloakable Fabricator
        urb4203 = 'srb4313',--To Cloakable stealth gen  
        ueb1301 = 'seb1311',--To engineering Generator
        ueb1302 = 'seb1312',--To engineering Extractor
        ueb1303 = 'seb1313',--To engineering Fabricator   
        uab1301 = 'sab1311',--To shielded Generator
        uab1302 = 'sab1312',--To shielded Extractor
        uab1303 = 'sab1313',--To shielded Fabricator
        sab4102 = 'uab4202',--From Aeon T1 Shield
        seb4102 = 'ueb4202',--From UEF T1 Shield
        ssb4102 = 'xsb4202',--From Seraphim T1 Shield
        xsb1301 = 'ssb1311',--To Armored Generator
        xsb1302 = 'ssb1312',--To Armored Extractor
        xsb1303 = 'ssb1313',--To Armored Fabricator
        --srb5310 = 'srb5311',--Cybran wall into cybran gate. Caused issues.
    }
    for unitid, upgradeid in VanillasToUpgrade do
        if all_bps[unitid] and all_bps[upgradeid] then
            table.insert(all_bps[unitid].Categories, 'SHOWQUEUE')   
            
            if not all_bps[unitid].Display.Abilities then all_bps[unitid].Display.Abilities = {} end
            table.removeByValue(all_bps[unitid].Display.Abilities, '<LOC ability_upgradable>Upgradeable')--Preventing double ability in certain units.
            table.insert(all_bps[unitid].Display.Abilities, '<LOC ability_upgradable>Upgradeable')
            
            if not all_bps[unitid].Economy.RebuildBonusIds then all_bps[unitid].Economy.RebuildBonusIds = {} end
            table.insert(all_bps[unitid].Economy.RebuildBonusIds, upgradeid)
              
            if not all_bps[unitid].Economy.BuildableCategory then all_bps[unitid].Economy.BuildableCategory = {} end
            table.insert(all_bps[unitid].Economy.BuildableCategory, upgradeid)
               
            all_bps[unitid].General.UpgradesTo = upgradeid  
            all_bps[upgradeid].General.UpgradesFrom = unitid
            
            if not all_bps[unitid].Economy.BuildRate then all_bps[unitid].Economy.BuildRate = 15 end
            
            all_bps[unitid].General.CommandCaps.RULEUCC_Pause = true
        end
    end
    local UpgradesFromBase = {
        -- Base        Max
        urb1103 = 'srb1312',--To Cloakable Extractor
        ueb1103 = 'seb1312',--To engineering Extractor
        uab1103 = 'sab1312',--To shielded Extractor
        xsb1103 = 'ssb1312',--To Armored Extractor
    }  
    --This could potentially loop forever if someone broke the upgrade chain elsewhere
    for unitid, upgradeid in UpgradesFromBase do
        if all_bps[upgradeid] then
            local nextID = upgradeid 
            while true do
                if nextID == unitid then break end
                all_bps[nextID].General.UpgradesFromBase = unitid
                --LOG(all_bps[nextID].Description, unitid )
                if all_bps[nextID].General.UpgradesFrom then 
                    nextID = all_bps[nextID].General.UpgradesFrom
                else
                    break
                end
            end
        end
    end
end

--------------------------------------------------------------------------------
-- Torpedo bombers able to land on/in water
--------------------------------------------------------------------------------
 
function TorpedoBomberWaterLandCat(all_bps)

    local TorpedoBombers = {
        all_bps['sra0307'], #T3 Cybran
        all_bps['sea0307'], #T3 UEF
        all_bps['ssa0307'], #T3 Seraphim
        all_bps['xaa0306'], #T3 Aeon
        
        all_bps['ura0204'], #T2 Cybran
        all_bps['uea0204'], #T2 UEF
        all_bps['xsa0204'], #T2 Seraphim
        all_bps['uaa0204'], #T2 Aeon
        
        all_bps['sra0106'], #T1 Cybran
        all_bps['sea0106'], #T1 UEF
        all_bps['ssa0106'], #T1 Seraphim
        all_bps['saa0106'], #T1 Aeon
    }
    for arrayIndex, bp in TorpedoBombers do
        table.insert(bp.Categories, 'TRANSPORTATION') --transportation category allows aircraft to land on water.
        table.insert(bp.Categories, 'HOVER') --hover category stops torpedos from being fired upon them while landed.
        for i, v in bp.Weapon do
            if v.WeaponCategory == "Anti Navy" and v.FireTargetLayerCapsTable then
                v.FireTargetLayerCapsTable.Seabed = 'Seabed|Sub|Water'
                v.FireTargetLayerCapsTable.Sub = 'Seabed|Sub|Water'
                v.FireTargetLayerCapsTable.Water = 'Seabed|Sub|Water'
            end
        end
    end	
end

--------------------------------------------------------------------------------
-- My OCD GC health change change
--------------------------------------------------------------------------------
 
function RoundGalacticCollosusHealth(all_bps)
    if all_bps['ual0401'].Defense.Health == 99999 then all_bps['ual0401'].Defense.Health = 100000 end
    if all_bps['ual0401'].Defense.MaxHealth == 99999 then all_bps['ual0401'].Defense.MaxHealth = 100000 end
end

--------------------------------------------------------------------------------
-- Cost balance matching for between FAF and Steam versions of Forged Alliance
--------------------------------------------------------------------------------

function BrewLANMatchBalancing(all_bps)

    local UnitsList = {
------- T3 torpedo bombers to match Solace
        sra0307 = 'xaa0306',
        sea0307 = 'xaa0306',
        ssa0307 = 'xaa0306',
------- Sera T3 gunship to match Broadsword   
        ssa0305 = 'uea0305',
------- Air transports to be based  
        ssa0306 = 'xea0306',        
                           --Energy mass  b-time b-rate
        sra0306 = {'xea0306', 0.95, 0.95, 0.95,},
        saa0306 = {'xea0306', 2.75, 2.75, 2.75,},

------- ED5 built by field engineer balancing         
        urb4207 = {'urb4207', 1.5,  1.5,  2.25, },
        urb4206 = {'urb4206', 1,    1,    1,     2.25,},
    }   
     
    for unitid, targetid in UnitsList do
        if type(targetid) == 'string' then
            if all_bps[unitid] and all_bps[targetid] then
                all_bps[unitid].Economy.BuildCostEnergy = all_bps[targetid].Economy.BuildCostEnergy
                all_bps[unitid].Economy.BuildCostMass = all_bps[targetid].Economy.BuildCostMass     
                all_bps[unitid].Economy.BuildTime = all_bps[targetid].Economy.BuildTime
            end
        elseif type(targetid) == 'table' then
            local tid = targetid[1]
            if all_bps[unitid] and all_bps[tid] then
                all_bps[unitid].Economy.BuildCostEnergy = all_bps[tid].Economy.BuildCostEnergy * targetid[2]
                all_bps[unitid].Economy.BuildCostMass = all_bps[tid].Economy.BuildCostMass * targetid[3]     
                all_bps[unitid].Economy.BuildTime = all_bps[tid].Economy.BuildTime * targetid[4] 
                if all_bps[unitid].Economy.BuildRate and all_bps[tid].Economy.BuildRate and targetid[5] then 
                    all_bps[unitid].Economy.BuildRate = all_bps[tid].Economy.BuildRate * targetid[5]
                end
            end
        end    
    end
end

--------------------------------------------------------------------------------
-- Shield changes
--------------------------------------------------------------------------------
   
function BrewLANNavalShields(all_bps) 
    local Units = {
        --Cybran Shields
        urb4202 = {},
        urb4204 = {},
        urb4205 = {},
        urb4206 = {},
        urb4207 = {},   
        --UEF Shields
        seb4102 = {},
        ueb4202 = {},
        ueb4301 = {},
        --Aeon Shields
        sab4102 = {},
        uab4202 = {},
        uab4301 = {},
        --Seraphim Shields
        ssb4102 = {},
        xsb4202 = {},
        xsb4301 = {}, 
    }
    for k, v in Units do   
        if all_bps[k] then
            all_bps[k].General.Icon = 'amph'
            all_bps[k].Physics.BuildOnLayerCaps.LAYER_Water = true
            all_bps[k].Wreckage.WreckageLayers.Water = true
            if not all_bps[k].Display.Abilities then all_bps[k].Display.Abilities = {} end 
            if not table.find(all_bps[k].Display.Abilities, '<LOC ability_aquatic>Aquatic') then
                table.insert(all_bps[k].Display.Abilities, 1, '<LOC ability_aquatic>Aquatic')
            end
            --Waterlag visual compatability
            table.insert(all_bps[k].Categories, 'GIVEMELEGS')
        end
    end
end

--------------------------------------------------------------------------------
-- Work around for bombers destroying themselves on the Iron Curtain
--------------------------------------------------------------------------------

function BrewLANBomberDamageType(all_bps)
    for id, bp in all_bps do
        if table.find(bp.Categories, 'BOMBER') then
            if bp.Weapon then
                for i, weap in bp.Weapon do
                    if weap.NeedToComputeBombDrop then
                        if weap.DamageType == 'Normal' then
                            weap.DamageType = 'NormalBomb'
                        end
                    end 
                end 
            end
        end
    end
end

--------------------------------------------------------------------------------
-- The bit that makes BrewLAN blueprints not care where BrewLAN is installed
--------------------------------------------------------------------------------

function BrewLANRelativisticLinksUpdate(all_bps)
    if string.lower(BrewLANPath() ) != "/mods/brewlan" then
        all_bps.Unit.zzz0001.Desync = {
            "BrewLAN reports you installed it",
            "wrong; it should be at:",
            "/mods/brewlan",
            "but it's at:",
            string.lower(BrewLANPath()),
            "Everything should still work though.",
        }
        for id, bp in all_bps.Unit do
            if table.find(bp.Categories, 'PRODUCTBREWLAN' ) then
                PathTrawler(bp, "/mods/brewlan/", BrewLANPath() .. "/" )
            end
        end
        for id, bp in all_bps.Beam do
            if bp.Categories and table.find(bp.Categories, 'PRODUCTBREWLAN' ) then
                PathTrawler(bp, "/mods/brewlan/", BrewLANPath() .. "/" )
            end
        end
        --INFO: TrailEmitter
        --INFO: Beam
        --INFO: Emitter
        --INFO: Projectile
        --INFO: Prop
        --INFO: Mesh
        --INFO: Unit
    end
end

function PathTrawler(tbl, sfind, srepl)
    for k, v in tbl do
        if type(v) == "string" then
            if string.find(string.lower(v), sfind) then
                tbl[k] = string.gsub(string.lower(v), sfind, srepl)
            end 
        elseif type(v) == "table" then
            PathTrawler(tbl[k], sfind, srepl)
        end       
    end
end

--------------------------------------------------------------------------------
-- Eggs. Eggs everywhere
--------------------------------------------------------------------------------

function BrewLANMegalithEggs(all_bps)
    --First check the Megalith exists and can build
    if all_bps['xrl0403'] and all_bps['xrl0403'].Economy.BuildableCategory then
        local baseEgg = all_bps['srl0000']
        for id, bp in all_bps do
            if table.find(bp.Categories, 'MEGALITHEGG') then
                copyTableNoReplace(baseEgg, bp)
                table.insert(all_bps['xrl0403'].Economy.BuildableCategory, bp.BlueprintId)
                bp.Economy.BuildCostEnergy = all_bps[bp.Economy.BuildUnit].Economy.BuildCostEnergy
                bp.Economy.BuildCostMass = all_bps[bp.Economy.BuildUnit].Economy.BuildCostMass
                bp.Economy.BuildTime = all_bps[bp.Economy.BuildUnit].Economy.BuildTime
                bp.General.Icon = all_bps[bp.Economy.BuildUnit].General.Icon
                if string.lower(all_bps[bp.Economy.BuildUnit].Physics.MotionType) == "ruleumt_amphibious" then
                    bp.Physics.BuildOnLayerCaps.LAYER_Seabed = true
                end
            end
        end
    end
end
          
function copyTableNoReplace(source, target)
    for k, v in source do
        if type(v) == "table" then
            if not target[k] then
                target[k] = {}
            end
            copyTableNoReplace(v, target[k])
        else
            if not target[k] then
                target[k] = v
            end
        end
    end
end

--------------------------------------------------------------------------------
-- Do you want to build a snowman?
--------------------------------------------------------------------------------

function ExtractFrozenMeshBlueprint(all_bps)
    for id, bp in all_bps do
        local meshid = bp.Display.MeshBlueprint
        if meshid then
            local meshbp = original_blueprints.Mesh[meshid]
            if meshbp then
                local frozenbp = table.deepcopy(meshbp)
                if frozenbp.LODs then
                    for i,lod in frozenbp.LODs do
                        if lod.ShaderName == 'TMeshAlpha' or lod.ShaderName == 'NormalMappedAlpha' or lod.ShaderName == 'UndulatingNormalMappedAlpha' then
                            --lod.ShaderName = 'BlackenedNormalMappedAlpha'
                        else
                            lod.ShaderName = 'Aeon'
                            lod.SpecularName = BrewLANPath() .. '/env/common/frozen_specular.dds'
                            lod.NormalsName = BrewLANPath() .. '/env/common/frozen_normals.dds'
                        end
                    end
                end
                frozenbp.BlueprintId = meshid .. '_frozen'
                bp.Display.MeshBlueprintFrozen = frozenbp.BlueprintId
                MeshBlueprint(frozenbp)
            end
        end
    end
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------

end
