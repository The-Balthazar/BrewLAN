--------------------------------------------------------------------------------
-- Hook File: /lua/ui/lobby/restrictedUnitsData.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do
    local Units = { 
        ------------------------------------------------------------------------
        -- Default unit restrictions
        ------------------------------------------------------------------------
        GAMEENDERS = {
            "srb2401",
            "ssb2404",
        },
        BUBBLES = {
            --Tech 1 shields
            "sab4102",
            "seb4102",
            "ssb4102",
            --Cybran shields
            "urb4204",
            "urb4205",
            "urb4206",
            "urb4207",
            "srb4401",
            --Aeon Shielded T3 resource buildings
            "sab1311",
            "sab1312",
            "sab1313",
        },
        FABS = {
            "sab1313", 
            "seb1313",
            "srb1313",
            "ssb1313",
        },
        NUKE = {
            --Nuke Mines
            "srb2222",
            "seb2222",
            "sab2222",
            "ssb2222",
            --Mobile Anti-Nukes
            "sal0321",
            "sel0321",
            "srl0321",
            "ssl0321",
        },
        ------------------------------------------------------------------------
        -- FAF unit restrictions
        ------------------------------------------------------------------------
        WALL = {
            "MEDIUMWALL", 
            "MEDIUMWALLGATE",
            "HEAVYWALL",
            "HEAVYWALLGATE",
            "SHIELDWALL",
        },
        ENGISTATION = {
            --Seraphim Engi Stations
            "ssb0104",
            "ssb0204",
            "ssb0304",
            --UEF Engineering resource buildings
            "seb1311",
            "seb1312",
            "seb1313",
            --Hive and Kennel final forms
            "xeb0204",
            "xrb0304",
        },
        SALVAMAVOSCATH = {
            "srb2401", --Scathis MK II
            "srb2404", --Suthanus
        },
        EYE = {
            "seb3303", --Novax Observation Satelite
            "ssb3301", --Seraphim Optics Tracking Facility
            "seb3404", --PANOPTICON
        },
    }  
    for k, v in Units do
        --Checks the table exists, for the sake of FAF restrictions
        if restrictedUnits[k] then
            for i in v do  
                --Checks the unit exists, just in case and the new FaF restriction check
                if categories[v[i]] and restrictedUnits[k].categories then
                    table.insert(restrictedUnits[k].categories, v[i])
                --Are we FaF?
                elseif categories[v[i]] and restrictedUnits[k].categoryExpression then
                    restrictedUnits[k].categoryExpression = restrictedUnits[k].categoryExpression .. " + " .. v[i] 
                end
            end
        end
    end
    --Fixes the console exclusive UEF artillery shield breaking the no-bubbles restriction 
    if not categories.deb4303 and restrictedUnits.BUBBLES.categories then
        table.removeByValue(restrictedUnits.BUBBLES.categories, "deb4303")
    end
    if restrictedUnits.NUKE.categories then
        table.removeByValue(restrictedUnits.NUKE.categories, "xss0302")
    --Are we FaF?
    elseif restrictedUnits.NUKE.categoryExpression then
        --I don't think this actually works. Dont care enough to fix it.
        restrictedUnits.NUKE.categoryExpression = string.gsub(restrictedUnits.NUKE.categoryExpression, " + xss0302", "")
    end
end
