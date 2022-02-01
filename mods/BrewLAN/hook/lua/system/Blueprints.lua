--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do  -- In a do block so no one else can mess with the locals

local OldModBlueprints = ModBlueprints
local BrewLANPath

if _VERSION == "Lua 5.0.1" then
    local GetBrewLANPath = function()
        for i, mod in __active_mods do
            if mod.name == "BrewLAN" then
                return string.lower(mod.location)
            end
        end
    end
    BrewLANPath = GetBrewLANPath()
end

local function HasRXCat(bp, exp)
    if not bp.Categories then return end
    for i, cat in ipairs(bp.Categories) do
        if cat:find(exp) then return i end
    end
end

local function HasCat(bp, cat) return bp.Categories and table.find(bp.Categories, cat) end
local function HasBuildCat(bp)         return HasRXCat(bp, 'BUILTBY') end
local function HasEngineerBuildCat(bp) return HasRXCat(bp, 'BUILTBY.*ENGINEER') end
local function HasFieldBuildCat(bp)    return HasRXCat(bp, 'BUILTBY.*FIELD') end
local function HasFactoryBuildCat(bp)  return HasRXCat(bp, 'BUILTBY.*FACTORY') end
local function HasACUBuildCat(bp)      return HasRXCat(bp, 'BUILTBY.*COMMANDER') end
local function GetTechLevel(bp) return
    HasCat(bp, 'TECH1') and 1 or
    HasCat(bp, 'TECH2') and 2 or
    HasCat(bp, 'TECH3') and 3 or
    HasCat(bp, 'EXPERIMENTAL') and 4
end

function ModBlueprints(all_blueprints)
    OldModBlueprints(all_blueprints)

    local real_categories = {}
    local Gantries = {}

    for id, bp in all_blueprints.Unit do
        BrewLANSanityChecks(id, bp)
        --Category processing
        BrewLANCategoryChanges(id, bp)
        BrewLANGlobalCategoryAdditions(id, bp)
        --Data for future
        BrewLANGetRealCategories(id, bp, real_categories)
        BrewLANAddToGantryList(id, bp, Gantries)
    end

    -- One off scripts with no internal loop
    BrewLANRoundGalacticCollosusHealth(all_blueprints.Unit.ual0401)

    BrewLANBuildCatChanges(all_blueprints.Unit, real_categories)
    BrewLANBuildCatChangesAI(all_blueprints.Unit, real_categories)
    UpgradeableToBrewLAN(all_blueprints.Unit)
    BrewLANMatchBalancing(all_blueprints.Unit)

    BrewLANFAFExclusiveChanges(all_blueprints)

    --BrewLANChangesForDominoModSupport(all_blueprints.Unit)

    for id, bp in all_blueprints.Unit do

        BrewLANNavalEngineerCatFixes(id, bp)

        -- Specific unit changes
        BrewLANTorpedoBomberWaterLanding(id, bp)
        BrewLANNavalShields(id, bp)
        BrewLANSatelliteUplinkForVanillaUnits(id, bp)

        --Build Category processing
        BrewLANGantryBuildList(id, bp, Gantries)
        BrewLANGantryTechShareCheck(id, bp)
        BrewLANHeavyWallBuildList(id, bp)
        BrewLANNavalEngineersBuildList(id, bp)

        -- Specific characteristic changes
        BrewLANBomberDamageType(id, bp)
        BrewLANMegalithEggs(id, bp, all_blueprints.Unit, all_blueprints.Unit.xrl0403, all_blueprints.Unit.srl0000)

        --BrewLANExtractFrozenMeshBlueprint(id, bp)
    end

    BrewLANGenerateFootprintDummyUnits(all_blueprints.Unit)
    BrewLANRelativisticLinksUpdate(all_blueprints)
end

function WikiBlueprints(all_blueprints)
    local Gantries = {}
    for id, bp in pairs(all_blueprints.Unit) do
        BrewLANAddToGantryList(id, bp, Gantries)
    end

    all_blueprints.Unit.sab0401.Economy.BuildableCategory = {'BUILTBYEXPERIMENTALFACTORY AEON AIR', 'BUILTBYIENGINE AIR'}
    all_blueprints.Unit.srb0401.Economy.BuildableCategory = {'BUILTBYEXPERIMENTALFACTORY CYBRAN LAND', 'BUILTBYARTHROLAB LAND'}
    all_blueprints.Unit.ssb0401.Economy.BuildableCategory = {'BUILTBYEXPERIMENTALFACTORY SERAPHIM NAVAL', 'BUILTBYSOUIYA NAVAL'}

    BrewLANBuildCatChanges(all_blueprints.Unit)
    UpgradeableToBrewLAN(all_blueprints.Unit)
    BrewLANMatchBalancing(all_blueprints.Unit)

    for id, bp in pairs(all_blueprints.Unit) do
        BrewLANNavalShields(id, bp)
        --BrewLANMegalithEggs(id, bp, all_blueprints.Unit, all_blueprints.Unit.xrl0403, all_blueprints.Unit.srl0000)  -- Wont do anything for the wiki since it checks Megalith exist first.
        BrewLANSatelliteUplinkForVanillaUnits(id, bp)
        BrewLANGantryBuildList(id, bp, Gantries)
        BrewLANHeavyWallBuildList(id, bp)
        BrewLANNavalEngineersBuildList(id, bp)
    end
end

--------------------------------------------------------------------------------
-- Sanity checks
--------------------------------------------------------------------------------

function BrewLANSanityChecks(id, bp)
    --Motion Type
    local motionTypes = {
        RULEUMT_Air                = true,
        RULEUMT_Amphibious         = true,
        RULEUMT_AmphibiousFloating = true,
        RULEUMT_Biped              = true,
        RULEUMT_Land               = true,
        RULEUMT_Hover              = true,
        RULEUMT_Water              = true,
        RULEUMT_SurfacingSub       = true,
        RULEUMT_None               = true,
    }
    local motionTypesLower = {
        ruleumt_air                = 'RULEUMT_Air',
        ruleumt_amphibious         = 'RULEUMT_Amphibious',
        ruleumt_amphibiousfloating = 'RULEUMT_AmphibiousFloating',
        ruleumt_biped              = 'RULEUMT_Biped',
        ruleumt_land               = 'RULEUMT_Land',
        ruleumt_hover              = 'RULEUMT_Hover',
        ruleumt_water              = 'RULEUMT_Water',
        ruleumt_surfacingsub       = 'RULEUMT_SurfacingSub',
        ruleumt_none               = 'RULEUMT_None',
    }
    --I'm pretty sure this is already required, but just in case
    -- for my own sanity
    if bp.Physics and bp.Physics.MotionType and not motionTypes[bp.Physics.MotionType] then
        _ALERT("Fixing malformed motion type "..bp.Physics.MotionType.." in unit "..id)

        bp.Physics.MotionType = motionTypesLower[string.lower(bp.Physics.MotionType)]

        if not bp.Physics.MotionType then
            _ALERT("Un-identifiable motion type on unit "..id.." giving 'None'")
            bp.Physics.MotionType = 'RULEUMT_None'
        end
    end
end

--------------------------------------------------------------------------------
-- Additional buildable categories
--------------------------------------------------------------------------------

function BrewLANGetRealCategories(id, bp, real_categories)
    if bp.Categories then
        for i, cat in bp.Categories do
            real_categories[cat] = true
        end
    end
end

--------------------------------------------------------------------------------

function BrewLANBuildCatChanges(all_bps, real_categories)
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
        uel0401 = {'BUILTBYLANDTIER3FACTORY UEF MOBILE CONSTRUCTION',}, -- FATBOY
        --TeaD tiny factories
        seb0101 = {'BUILTBYLANDTIER1FACTORY UEF MOBILE CONSTRUCTION',},
        srb0101 = {'BUILTBYLANDTIER1FACTORY CYBRAN MOBILE CONSTRUCTION',},
        sab0101 = {'BUILTBYLANDTIER1FACTORY AEON MOBILE CONSTRUCTION',},
        ssb0101 = {'BUILTBYLANDTIER1FACTORY SERAPHIM MOBILE CONSTRUCTION',},
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
        --Support Commanders
        ual0301 = {'BUILTBYTIER3FIELD AEON',},
        uel0301 = {'BUILTBYTIER3FIELD UEF',},
        url0301 = {'BUILTBYTIER3FIELD CYBRAN',},
        xsl0301 = {'BUILTBYTIER3FIELD SERAPHIM',},
    }
    for unitid, buildcat in pairs(units_buildcats) do
        if all_bps[unitid] and all_bps[unitid].Economy.BuildableCategory then   --Xtreme Wars crash fix here. They removed the Fatboys ability to build.
            for i in ipairs(buildcat) do
                --Check we can
                if not real_categories then
                    table.insert(all_bps[unitid].Economy.BuildableCategory, buildcat[i])
                    table.sort(all_bps[unitid].Economy.BuildableCategory)
                elseif CheckBuildCatConsistsOfRealCats(real_categories, buildcat[i]) then
                    table.insert(all_bps[unitid].Economy.BuildableCategory, buildcat[i])
                end
            end
        end
    end
end

function BrewLANBuildCatChangesAI(all_bps, real_categories)
    local units_buildcats = {
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
    }
    for unitid, buildcat in units_buildcats do
        if all_bps[unitid] and all_bps[unitid].Economy.BuildableCategory then
            for i in buildcat do
                if CheckBuildCatConsistsOfRealCats(real_categories, buildcat[i]) then
                    table.insert(all_bps[unitid].Economy.BuildableCategory, buildcat[i])
                end
            end
        end
    end
end

function CheckBuildCatConsistsOfRealCats(real_categories, buildcat)
    if type(real_categories) == 'table' and type(buildcat) == 'string' then
        local invalidcats = 0
        string.gsub(buildcat, "(%w+)",
            function(w)
                if not real_categories[w] then
                    invalidcats = invalidcats + 1
                end
            end
        )
        return invalidcats == 0
    else
        WARN("Function 'CheckBuildCatConsistsOfRealCats' requires two args; an array of strings, and a string. Recieved " .. type(real_categories) .. " and " .. type(buildcat) .. ".")
        return false
    end
end

--------------------------------------------------------------------------------
-- Fixes for land-built factories being able to build non-land engineers non-specifically.
--------------------------------------------------------------------------------

function BrewLANNavalEngineerCatFixes(id, bp)
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
    -- If table doesn't exist, it's 'Land'. If a key doesnt exist, but the table does, that key is false.
    if bp.Physics and bp.Economy and (bp.Physics.BuildOnLayerCaps and not bp.Physics.BuildOnLayerCaps.LAYER_Water or not bp.Physics.BuildOnLayerCaps) and bp.Economy.BuildableCategory then
        for i, cat in bp.Economy.BuildableCategory do
            for index, cattable in cats_table do
                if cat == cattable[1] then
                    bp.Economy.BuildableCategory[i] = cattable[2]
                end
            end
        end
    end
end

--------------------------------------------------------------------------------
-- Unit category changes
--------------------------------------------------------------------------------

function BrewLANCategoryChanges(id, bp)
    local Units = {
        --[[ED1]]       urb4202 = { 'BUILTBYTIER1ENGINEER', 'BUILTBYTIER2ENGINEER', 'BUILTBYTIER3ENGINEER', 'BUILTBYTIER2COMMANDER', 'BUILTBYTIER3COMMANDER', 'TECH1', r = 'TECH2'},
        --[[ED2]]       urb4204 = { 'TECH1', r = 'TECH2' },
        --[[ED3]]       urb4205 = { 'BUILTBYTIER2ENGINEER', 'BUILTBYTIER3ENGINEER', 'BUILTBYTIER2COMMANDER', 'BUILTBYTIER3COMMANDER' },
        --[[ED4]]       urb4206 = { 'BUILTBYTIER3ENGINEER', 'BUILTBYTIER3COMMANDER', 'TECH3', r = 'TECH2' },
        --[[ED5]]       urb4207 = { 'BUILTBYTIER3FIELD', 'TECH3', r = 'TECH2' },
        --[[Flak Egg]]  xrl0004 = {'TECH3', r = 'TECH2'},
        --[[Hive 1]]    xrb0104 = {r = 'ENGINEER'},
        --[[Hive 2]]    xrb0204 = {r = 'ENGINEER'},
        --[[Hive 3]]    xrb0304 = {'BUILTBYTIER3ENGINEER','BUILTBYTIER3COMMANDER','TECH3', r = {'TECH2', 'ENGINEER'} },
        --[[Kennel]]    xeb0204 = {'BUILTBYTIER3ENGINEER','BUILTBYTIER3COMMANDER'},
        --[[Ravager]]   xeb2306 = {'SIZE4', r = 'SIZE12'},
        --[[Eye of R]]  xab3301 = {'SIZE16', r = 'SIZE4'},

        --Experimentals
        --[[Colossus]]  ual0401 = {'DARKNESSIMMUNE'},
        --[[Paragon]]   xab1401 = {'SORTECONOMY'},
        --[[Salvation]] xab2307 = {'EXPERIMENTAL', r = 'TECH3'},
        --[[Mavor]]     ueb2401 = {'SORTSTRATEGIC'},
        ----[[Atlantis]]  ues0401 = {'TECH3', r = 'EXPERIMENTAL'} -- This fixes the Atlantis not coming out of the Gantry without diving, but obviously isn't acceptable.
        --[[Novax]]     xeb2402 = {NoBuild = true},
        --[[Scathis]]   url0401 = {NoBuild = true},
        --[[Megalith]]  xrl0403 = {'GANTRYSHARETECH'},
        --[[Iyadesy]]   ssl0403 = {'GANTRYSHARETECH'},
    }

    local data = Units[id]

    if data and bp and bp.Categories then
        if not data.NoBuild then
            for i in data do
                if i == 'r' then
                    if type(data.r) == 'string' then
                        table.removeByValue(bp.Categories, data.r)
                    elseif type(data.r) == 'table' then
                        for i in data.r do
                            table.removeByValue(bp.Categories, data.r[i])
                        end
                    end
                end
                if i ~= 'r' then
                    table.insert(bp.Categories, data[i])
                end
            end
        else
            local buildcat = HasBuildCat(bp)
            while buildcat do
                table.remove(bp.Categories, buildcat)
                buildcat = HasBuildCat(bp)
            end
        end
    end
end

--------------------------------------------------------------------------------
-- Global category additions
--------------------------------------------------------------------------------

function BrewLANGlobalCategoryAdditions(id, bp)
    local Cats = {
        'DRAGBUILD',
    }
    if bp.Categories then
        for i, cat in Cats do
            if not HasCat(bp, cat) then
                table.insert(bp.Categories, cat)
            end
        end
    end
end

--------------------------------------------------------------------------------
-- Satellite uplink
--------------------------------------------------------------------------------

function BrewLANSatelliteUplinkForVanillaUnits(id, bp)
    local units = {
        --Vanilla T3 sensors
        ueb3104 = 1,
        urb3104 = 1,
        uab3104 = 1,
        xsb3104 = 1,
        --R&D T3 sensors
        sab3301 = 3,
        seb3301 = 3,
        srb3301 = 3,
        ssb3302 = 3,
    }

    if not units[id] then return end

    if bp and bp.Categories and bp.Display then
        if not bp.Display.Abilities then
            bp.Display.Abilities = {}
        end
        table.insert(bp.Categories, 'SATELLITEUPLINK')
        table.insert(bp.Display.Abilities, '<LOC ability_satellite_uplink>Satellite Uplink')
        table.insert(bp.Display.Abilities, '<LOC ability_satellite_cap_'.. units[id] ..'>Satellite Capacity: +' .. units[id])
        bp.General.SatelliteCapacity = units[id]
    end
end

--------------------------------------------------------------------------------
-- Allowing other experimentals that look like they fit to be gantry buildable
--------------------------------------------------------------------------------

function BrewLANAddToGantryList(id, bp, Gantries)
    if bp.AI and bp.AI.Experimentals then
        Gantries[id] = {
            bp = bp,
            Reqs = bp.AI.Experimentals.Requirements,
            BuildCat = bp.AI.Experimentals.BuildableCategory
        }
    end
end

function BrewLANGantryBuildList(id, bp, Gantries)
    --This section is entirely because, as usual for a FAF function being over zealous, FAF support factories get fucking everywhere.
    if (not bp.Categories) or bp.Physics.MotionType == 'RULEUMT_None' then return end
    if HasFactoryBuildCat(bp) then
        table.insert(bp.Categories, 'BUILTBYEXPERIMENTALFACTORY')
    end

    for gantryId, info in pairs(Gantries) do
        local GivenCat

        if ((bp.Physics.SkirtSizeX or 0) < info.Reqs.SkirtSizeX)
        and HasCat(bp, 'NEEDMOBILEBUILD')
        and (HasEngineerBuildCat(bp) or HasACUBuildCat(bp)) then
            if not HasCat(bp, info.BuildCat) then
                table.insert(bp.Categories, info.BuildCat)
            end
            GivenCat = true
        end

        --Populate the Gantry AI table, so my dumb AI scripts will use them.
        if (GivenCat or HasCat(bp, info.BuildCat)) and HasCat(bp, 'EXPERIMENTAL') then
            local GantryBuildGroup = bp.Physics.MotionType == 'RULEUMT_Air' and 'Air' or 'Other'
            table.insert(info.bp.AI.Experimentals[GantryBuildGroup], {id})
        end
    end
end

--------------------------------------------------------------------------------
-- Allowing other experimentals that look like they fit to be gantry buildable
--------------------------------------------------------------------------------

function BrewLANGantryTechShareCheck(id, bp)
    if bp.Economy and bp.Economy.BuildableCategory
    and not HasCat(bp,'GANTRYSHARETECH')
    and (HasCat(bp,'FACTORY') or HasCat(bp,'ENGINEER'))
    and (HasCat(bp,'TECH3') or HasCat(bp,'EXPERIMENTAL') or HasCat(bp,'COMMAND')) then
        for i, buildcat in ipairs(bp.Economy.BuildableCategory) do
            if buildcat:find'FACTORY' or buildcat:find'ENGINEER' or buildcat:find'COMMANDER' then
                table.insert(bp.Categories, 'GANTRYSHARETECH')
                break
            end
        end
    end
end

--------------------------------------------------------------------------------
-- Propperly choosing what should be buildable by naval engineers
--------------------------------------------------------------------------------

function BrewLANNavalEngineersBuildList(id, bp)
    local caps = bp.Physics and bp.Physics.BuildOnLayerCaps
    local mt = bp.Physics and bp.Physics.MotionType
    local tech = GetTechLevel(bp)

    if bp.Categories and tech and HasBuildCat(bp)
    and (
        (mt == 'RULEUMT_None' and caps and (caps.LAYER_Seabed or caps.LAYER_Sub or caps.LAYER_Water))
        or
        (HasCat(bp,'NEEDMOBILEBUILD') and (mt ~= 'RULEUMT_None' and mt ~= 'RULEUMT_Biped' and mt ~= 'RULEUMT_Land'))
    )
    then
        tech = math.min(tech, 3)
        for i=tech, 3 do
            table.insert(bp.Categories, 'BUILTBYTIER'..i..'NAVALENGINEER')
        end
    end
end

--------------------------------------------------------------------------------
-- Propperly choosing what should be buildable by the heavy walls.
--------------------------------------------------------------------------------

function BrewLANHeavyWallBuildList(id, bp)
    if bp.Categories then
        --Check its not hard coded to be buildable.
        if not HasCat(bp, 'BUILTBYTIER3WALL')
        and bp.Physics.MotionType == 'RULEUMT_None'
        and (
            not bp.Physics.BuildRestriction -- default usually isn't written in
            or bp.Physics.BuildRestriction == 'RULEUBR_None'
        )
        and (
            not bp.Physics.BuildOnLayerCaps -- if undefined it's just Land.
            or bp.Physics.BuildOnLayerCaps.LAYER_Land
        )
        and not HasCat(bp, 'WALL')
        and not HasCat(bp, 'SHIELDWALL')
        and not HasCat(bp, 'MINE')
        and (
            HasEngineerBuildCat(bp) or
            HasFieldBuildCat(bp)
        )
        and (
            HasCat(bp, 'DEFENSE') or
            HasCat(bp, 'DIRECTFIRE') or
            HasCat(bp, 'INDIRECTFIRE') or
            HasCat(bp, 'ANTIAIR')
        ) then

            --Check it wouldn't overlap badly with the wall
            local fits, correct = {}, {}
            for _, A in ipairs{'X','Z'} do
                local size = bp.Footprint and bp.Footprint['Size'..A] or (bp['Size'..A] and math.ceil(bp['Size'..A]) or 1)
                local skirt = bp.Physics['SkirtSize'..A] or size

                fits[A] = size ~= 2 and size <= 3 and skirt <= 3
                correct[A] = fits[A] and size == 3
            end

            if fits.X and fits.Z then
                table.insert(bp.Categories, 'BUILTBYTIER3WALL')

                if bp.Physics.FlattenSkirt then
                    bp.Physics.ConditionalFlattenSkirt = true
                end
                if correct.X or correct.Z and not bp.Footprint then
                    bp.Footprint = {}
                end
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
    for unitid, upgradeid in pairs(VanillasToUpgrade) do
        if all_bps[unitid] and all_bps[upgradeid] then

            if not all_bps[unitid].Categories then all_bps[unitid].Categories = {} end
            table.insert(all_bps[unitid].Categories, 'SHOWQUEUE')

            if not all_bps[unitid].Display then all_bps[unitid].Display = {} end
            if not all_bps[unitid].Display.Abilities then all_bps[unitid].Display.Abilities = {} end
            table.removeByValue(all_bps[unitid].Display.Abilities, '<LOC ability_upgradable>Upgradeable')--Preventing double ability in certain units.
            table.insert(all_bps[unitid].Display.Abilities, '<LOC ability_upgradable>Upgradeable')

            if not all_bps[unitid].Economy then all_bps[unitid].Economy = {} end
            --if not all_bps[unitid].Economy.RebuildBonusIds then all_bps[unitid].Economy.RebuildBonusIds = {} end
            --table.insert(all_bps[unitid].Economy.RebuildBonusIds, upgradeid)

            if not all_bps[unitid].Economy.BuildableCategory then all_bps[unitid].Economy.BuildableCategory = {} end
            table.removeByValue(all_bps[unitid].Economy.BuildableCategory, upgradeid) -- Preventing doubles
            table.insert(all_bps[unitid].Economy.BuildableCategory, upgradeid)

            if not all_bps[unitid].General then all_bps[unitid].General = {} end
            all_bps[unitid].General.UpgradesTo = upgradeid
            all_bps[upgradeid].General.UpgradesFrom = unitid

            if not all_bps[unitid].Economy.BuildRate then all_bps[unitid].Economy.BuildRate = 15 end

            if not all_bps[unitid].General.CommandCaps then all_bps[unitid].General.CommandCaps = {} end
            all_bps[unitid].General.CommandCaps.RULEUCC_Pause = true
        end
    end

    if _VERSION == "Lua 5.0.1" then
        local UpgradesFromBase = {
            -- Base        Max
            urb1103 = 'srb1312',--To Cloakable Extractor
            ueb1103 = 'seb1312',--To engineering Extractor
            uab1103 = 'sab1312',--To shielded Extractor
            xsb1103 = 'ssb1312',--To Armored Extractor
        }
        --This could potentially loop forever if someone broke the upgrade chain elsewhere
        for unitid, upgradeid in pairs(UpgradesFromBase) do
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
end

--------------------------------------------------------------------------------
-- Torpedo bombers able to land on/in water
--------------------------------------------------------------------------------

function BrewLANTorpedoBomberWaterLanding(id, bp)
    local TorpedoBombers = {
        sra0307 = true, --T3 Cybran
        sea0307 = true, --T3 UEF
        ssa0307 = true, --T3 Seraphim
        xaa0306 = true, --T3 Aeon

        ura0204 = true, --T2 Cybran
        uea0204 = true, --T2 UEF
        xsa0204 = true, --T2 Seraphim
        uaa0204 = true, --T2 Aeon

        sra0106 = true, --T1 Cybran
        sea0106 = true, --T1 UEF
        ssa0106 = true, --T1 Seraphim
        saa0106 = true, --T1 Aeon
    }

    if not TorpedoBombers[id] then return end

    --Check they exist, and have all their things.
    if bp and bp.Categories and bp.Weapon then
        table.insert(bp.Categories, 'TRANSPORTATION') --transportation category allows aircraft to land on water.
        if not HasCat(bp, 'TORPEDOBOMBER') then
            table.insert(bp.Categories, 'TORPEDOBOMBER')
        end
        --table.insert(bp.Categories, 'HOVER') --hover category stops torpedos from being fired upon them while landed.
        for i, v in bp.Weapon do
            if v.FireTargetLayerCapsTable and v.FireTargetLayerCapsTable.Land then
                v.FireTargetLayerCapsTable.Water = v.FireTargetLayerCapsTable.Land
            end
        end
    end
end

--------------------------------------------------------------------------------
-- My OCD GC health change change
--------------------------------------------------------------------------------

function BrewLANRoundGalacticCollosusHealth(colossus)
    for i, v in {'Health', 'MaxHealth'} do
        if colossus.Defense[v] == 99999 then colossus.Defense[v] = 100000 end
    end
end

--------------------------------------------------------------------------------
-- Balance matching for between FAF, Steam, and retail versions balancing
--------------------------------------------------------------------------------

function MathRoundTo(val, round)
    if type(round) == 'number' and type(val) == 'number' then
        return math.floor((val / round) + 0.5) * round
    else
        return val
    end
end

function MathRoundAppropriately(val)
    if val <= 25 then
        return val
    elseif val <= 1000 then
        return MathRoundTo(val, 5)
    else
        return MathRoundTo(val, 25)
    end
end

function BrewLANMatchBalancing(all_bps)
    local UnitsList = {
        ------- T1 gunships
        saa0105 = {TargetID = 'xra0105', Affects = {'Veteran'}},
        sea0105 = {TargetID = 'xra0105', Affects = {'Veteran'}},
        sra0105 = {TargetID = 'xra0105', Affects = {'Veteran'}},
        ------- T3 torpedo bombers to match Solace
        sra0307 = {TargetID = 'xaa0306', Affects = {'Transport', 'Economy'}},
        sea0307 = {TargetID = 'xaa0306', Affects = {'Transport', 'Economy'}},
        ssa0307 = {TargetID = 'xaa0306', Affects = {'Transport', 'Economy'}},
        ------- Field engineers
        sel0119 = {
            TargetID = 'xel0209',
            BaseMult = 0.265,
            Affects = {'Economy', 'Intel'},
            Mults = {
                Intel = 1,
                Economy = {
                    MaintenanceConsumptionPerSecondEnergy = 1/3,
                    BuildRate = 0.5,
                    StorageEnergy = 0.5,
                    StorageMass = 1/3,
                },
            },
        },
        --sel0209 = {TargetID = 'xel0209', Affects = {'Economy'}}
        sel0319 = {
            TargetID = 'xel0209',
            Affects = {'Economy', 'Intel'},
            Mults = {
                Intel = 1,
                Economy = {
                    BuildCostEnergy = 3.625,
                    BuildCostMass = 3,
                    BuildRate = 1.5,
                    BuildTime = 2.4,
                    StorageEnergy = 2.5,
                    StorageMass = 5/3,
                },
            },
        },

        sal0119 = {
            TargetID = 'xel0209',
            BaseMult = 0.265,
            Mults = {
                Economy = {
                    MaintenanceConsumptionPerSecondEnergy = 1/3,
                    BuildRate = 0.5,
                    StorageEnergy = 0.5,
                    StorageMass = 1/3,
                },
            },
        },
        sal0209 = 'xel0209',
        sal0319 = {
            TargetID = 'xel0209',
            Mults = {
                Economy = {
                    BuildCostEnergy = 3.625,
                    BuildCostMass = 3,
                    BuildRate = 1.5,
                    BuildTime = 2.4,
                    StorageEnergy = 2.5,
                    StorageMass = 5/3,
                },
            },
        },

        srl0119 = {
            TargetID = 'xel0209',
            BaseMult = 0.265,
            Mults = {
                Economy = {
                    MaintenanceConsumptionPerSecondEnergy = 1/3,
                    BuildRate = 0.5,
                    StorageEnergy = 0.5,
                    StorageMass = 1/3,
                },
            },
        },
        srl0209 = 'xel0209',
        srl0319 = {
            TargetID = 'xel0209',
            Mults = {
                Economy = {
                    BuildCostEnergy = 3.625,
                    BuildCostMass = 3,
                    BuildRate = 1.5,
                    BuildTime = 2.4,
                    StorageEnergy = 2.5,
                    StorageMass = 5/3,
                },
            },
        },

        ssl0119 = {
            TargetID = 'xel0209',
            BaseMult = 0.265,
            Mults = {
                Economy = {
                    BuildRate = 0.5,
                    StorageEnergy = 0.5,
                    StorageMass = 1/3,
                },
            },
        },
        ssl0219 = 'xel0209',
        ssl0319 = {
            TargetID = 'xel0209',
            Mults = {
                Economy = {
                    BuildCostEnergy = 3.625,
                    BuildCostMass = 3,
                    BuildRate = 1.5,
                    BuildTime = 2.4,
                    StorageEnergy = 2.5,
                    StorageMass = 5/3,
                },
            },
        },
        ------- Sera T3 gunship to match Broadsword
        ssa0305 = 'uea0305',
        ------- Air transports to be based
        ssa0306 = {
            TargetID ='xea0306',
            Affects = {
                'Economy',
                'Veteran',
            },
            Mults = {
                Economy = 7/6,
            },
        },
        sra0306 = {
            TargetID = 'xea0306',
            Affects = {
                'Economy',
                'Veteran',
            },
            Mults = {
                Economy = {
                    BuildCostEnergy = 4/6,
                    BuildCostMass = 4/6,
                    BuildTime = 4/6,
                    MaintenanceConsumptionPerSecondEnergy = 0.4,
                },
            },
        },
        saa0306 = {
            TargetID = 'xea0306',
            BaseMult = 2.75,
            Affects = {
                'Economy',
                'Veteran',
            },
            Mults = {
                Economy = {
                    MaintenanceConsumptionPerSecondEnergy = 2,
                },
                Veteran = 1,
            },
        },
        -- Mobile shield generators
        sal0322 = {
            TargetID = 'ual0307',
            Affects = {'Shield', 'Economy'},
            Mults = {
                Shield = {
                    ShieldMaxHealth = 1.1,
                    ShieldRegenRate = 3,
                    ShieldSize = 1.25,
                    ShieldVerticalOffset = 1.25,
                },
                Economy = {
                    BuildCostEnergy = 5,
                    BuildCostMass = 5,
                    BuildTime = 5,
                    MaintenanceConsumptionPerSecondEnergy = 2,
                },
            },
        },
        sel0322 = {
            TargetID = 'uel0307',
            Affects = {'Shield', 'Economy'},
            Mults = {
                Shield = {
                    ShieldMaxHealth = 2.2,
                    ShieldRechargeTime = 2,
                    ShieldRegenRate = 2,
                    ShieldSize = 1.25,
                    ShieldVerticalOffset = 1.25,
                },
                Economy = {
                    BuildCostEnergy = 5,
                    BuildCostMass = 5,
                    BuildTime = 5,
                    MaintenanceConsumptionPerSecondEnergy = 2,
                },
            },
        },
        ssl0222 = {
            TargetID = 'xsl0307',
            Affects = {'Shield', 'Economy'},
            Mults = {
                Shield = {
                    ShieldMaxHealth = 0.45,
                    ShieldRechargeTime = 0.5,
                    ShieldRegenRate = 0.5,
                    ShieldSize = 0.8,
                    ShieldVerticalOffset = 0.8,
                },
                Economy = {
                    BuildCostEnergy = 0.2,
                    BuildCostMass = 0.2,
                    BuildTime = 0.2,
                    MaintenanceConsumptionPerSecondEnergy = 0.5,
                },
            },
        },
        ------- Average between two other units
        --T2 recon/decoy/stealths
        sea0201 = {TargetID = {'uea0101', 'uea0302'}, Affects = {'Economy', 'Intel', 'Transport'}},
        ssa0201 = {TargetID = {'xsa0101', 'xsa0302'}, Affects = {'Economy', 'Intel', 'Transport'}},
        sra0201 = {TargetID = {'ura0101', 'ura0302'}, Affects = {'Economy', 'Intel', 'Transport'}},
        --saa0201 = {TargetID = {'uaa0101', 'uaa0302'}, Affects = {'Economy', 'Intel', 'Transport'}}, --Can't have multiple shared keys, don't feel like rewriting to accomodate.
        saa0201 = {TargetID = 'uaa0303', Affects = {'Air'}}, --It's imporant that it moves like an ASF
        sra0310 = {TargetID = 'ura0303', Affects = {'Air'}}, --It's imporant that it moves like an ASF
        sea0310 = {TargetID = 'uea0303', Affects = {'Air'}}, --It's imporant that it moves like an ASF
        ------- ED5 built by field engineer balancing
        urb4206 = {
            TargetID = 'urb4206',
            BaseMult = 1,
            Mults = {
                Economy = {
                    BuildRate = 2.25
                },
            },
        },
        urb4207 = {
            TargetID = 'urb4207',
            BaseMult = 1,
            Mults = {
                Economy = {
                    BuildCostEnergy = 1.5,
                    BuildCostMass = 1.5,
                    BuildTime = 2.25,
                },
            },
        },
        -- Fabricators
        sab1313 = {
            TargetID = 'uab1303',
            Affects = {'Defense', 'Economy'},
            Mults = {
                Defense = {
                    Health = 1.5,
                    MaxHealth = 1.5,
                },
                Economy = {
                    BuildCostEnergy = 1.35,
                    BuildCostMass = 1.35,
                    BuildTime = 1.35,
                    MaintenanceConsumptionPerSecondEnergy = 19/14,
                    ProductionPerSecondMass = 1.25,
                },
            }
        },
        srb1313 = {
            TargetID = 'urb1303',
            Affects = {'Defense', 'Economy'},
            Mults = {
                Defense = {
                    Health = 1.5,
                    MaxHealth = 1.5,
                },
                Economy = {
                    BuildCostEnergy = 1.35,
                    BuildCostMass = 1.35,
                    BuildTime = 1.35,
                    MaintenanceConsumptionPerSecondEnergy = 1.5,
                    ProductionPerSecondMass = 1.25,
                },
            }
        },
        seb1313 = {
            TargetID = 'ueb1303',
            Affects = {'Defense', 'Economy'},
            Mults = {
                Defense = {
                    Health = 1.5,
                    MaxHealth = 1.5,
                },
                Economy = {
                    BuildCostEnergy = 1.35,
                    BuildCostMass = 1.35,
                    BuildTime = 1.35,
                    MaintenanceConsumptionPerSecondEnergy = 1.25,
                    ProductionPerSecondMass = 1.25,
                },
            }
        },
        ssb1313 = {
            TargetID = 'xsb1303',
            Affects = {'Defense', 'Economy'},
            Mults = {
                Defense = {
                    Health = 2.5,
                    MaxHealth = 2.5,
                },
                Economy = {
                    BuildCostEnergy = 1.35,
                    BuildCostMass = 1.35,
                    BuildTime = 1.35,
                    MaintenanceConsumptionPerSecondEnergy = 1.25,
                    ProductionPerSecondMass = 1.25,
                },
            }
        },
    }

    for unitid, data in pairs(UnitsList) do
        if _VERSION ~= "Lua 5.0.1" and all_bps[unitid] then
            all_bps[unitid].WikiInfoboxNote = '<LOC wiki_infobox_stats_note>Note: This unit has its stats redefined<br />at the start of the game.'
            all_bps[unitid].WikiBalance = {
                ReferenceIDs = {
                    data.TargetID and data.TargetID[1] or data.TargetID or data,
                    data.TargetID and data.TargetID[2] or nil
                },
                Affects = data.Affects or {'Economy'},
            }
        end
        if type(data) == 'string' then
            if all_bps[unitid] and all_bps[data] then
                for key, val in pairs(all_bps[unitid].Economy) do
                    if type(val) == 'number' and val ~= 0 then
                        all_bps[unitid].Economy[key] = val
                    end
                end
            end
        elseif type(data) == 'table' then
            local tid = data.TargetID
            local Affects = data.Affects or {'Economy'}
            if all_bps[unitid] and (all_bps[tid[1]] and all_bps[tid[2]] or all_bps[tid]) then
                SPEW("Syncronising balance for " .. unitid)
                for i, tablename in ipairs(Affects) do

                    local function GetRef(id, key)
                        return all_bps[id] and
                        (
                            tablename == 'Shield'
                              and all_bps[id].Defense[tablename]
                              and all_bps[id].Defense[tablename][key]
                            or all_bps[id][tablename]
                              and all_bps[id][tablename][key]
                        )
                    end

                    local function GetValidRef(id, key)
                        local ref = GetRef(id, key)
                        return type(ref) == 'number' and ref
                    end

                    local function GetMult(key)
                        return data.Mults and type(data.Mults[tablename]) == 'number' and data.Mults[tablename]
                        or (data.Mults and data.Mults[tablename] and data.Mults[tablename][key])
                        or data.BaseMult
                        or 1
                    end

                    for key, val in pairs(tablename == 'Shield' and all_bps[unitid].Defense.Shield or all_bps[unitid][tablename]) do

                        local ref = GetValidRef(tid, key)
                        local refA = GetValidRef(tid[1], key)
                        local refB = GetValidRef(tid[2], key)

                        if type(val) == 'number' and ((ref and ref~=0) or (refA and refA~=0) and (refB and refB~=0)) then

                            local mult = GetMult(key)
                            local rawnumber = ref or (refA + refB) * 0.5

                            if mult and rawnumber then
                                (tablename == 'Shield' and all_bps[unitid].Defense.Shield or all_bps[unitid][tablename])[key] = MathRoundAppropriately(rawnumber * mult)
                            end
                        end
                    end
                end
            end
        end
    end
end

function BrewLANFAFExclusiveChanges(all_bps)
    if string.sub(GetVersion(),1,3) == '1.5' and tonumber(string.sub(GetVersion(),5)) > 3603 then
        for id, bp in all_bps.Unit do
            if bp.Categories and string.sub(bp.Source, 1, 13) == '/mods/brewlan' then
                if (bp.Physics.MotionType == 'RULEUMT_Air' or bp.Physics.MotionType == 'RULEUMT_Hover')
                and bp.Wreckage.WreckageLayers then
                    bp.Wreckage.WreckageLayers.Seabed = true
                    bp.Wreckage.WreckageLayers.Sub = true
                    bp.Wreckage.WreckageLayers.Water = true
                end
                if HasCat(bp, 'NEEDMOBILEBUILD') then
                    table.insert(bp.Categories, 'CQUEMOV')
                end
            end
            if bp.Weapon then
                for i, wep in bp.Weapon do
                    if wep.TargetType == 'RULEWTT_Projectile' and wep.TargetRestrictOnlyAllow and string.find(wep.TargetRestrictOnlyAllow, 'STRATEGIC') and wep.Damage and wep.Damage < 100 then
                        wep.Damage = wep.Damage * 1000
                    end
                end
            end
        end
        for id, bp in all_bps.Projectile do
            if bp.Categories and HasCat(bp, 'STRATEGIC') and bp.Defense and bp.Defense.Health and bp.Defense.Health < 100 then
                bp.Defense.Health = bp.Defense.Health * 1000
                bp.Defense.MaxHealth = (bp.Defense.Health or bp.Defense.MaxHealth) * 1000
            end
        end
    end
end

--------------------------------------------------------------------------------
-- Shield changes
--------------------------------------------------------------------------------

function BrewLANNavalShields(id, bp)
    local Units = {
        --Cybran Shields
        urb4202 = true,
        urb4204 = true,
        urb4205 = true,
        urb4206 = true,
        urb4207 = true,
        --UEF Shields
        seb4102 = true,
        ueb4202 = true,
        ueb4301 = true,
        --Aeon Shields
        sab4102 = true,
        uab4202 = true,
        uab4301 = true,
        --Seraphim Shields
        ssb4102 = true,
        xsb4202 = true,
        xsb4301 = true,
    }

    if not Units[id] then return end

    bp.General.Icon = 'amph'
    --This might not be populated, and this is the default if it isn't
    if not bp.Physics.BuildOnLayerCaps then
        bp.Physics.BuildOnLayerCaps = {
            LAYER_Land = true
        }
    end
    bp.Physics.BuildOnLayerCaps.LAYER_Water = true
    if bp.Wreckage and bp.Wreckage.WreckageLayers then
        bp.Wreckage.WreckageLayers.Water = true
    end
    if not bp.Display.Abilities then bp.Display.Abilities = {} end
    if not table.find(bp.Display.Abilities, '<LOC ability_aquatic>Aquatic') then
        table.insert(bp.Display.Abilities, 1, '<LOC ability_aquatic>Aquatic')
    end
    --Waterlag visual compatability
    bp.Display.GiveMeLegs = true
end

--------------------------------------------------------------------------------
-- Work around for bombers destroying themselves on the Iron Curtain
--------------------------------------------------------------------------------

function BrewLANBomberDamageType(id, bp)
    if bp.Weapon then
        for i, weap in bp.Weapon do
            if weap.NeedToComputeBombDrop and weap.DamageType == 'Normal' then
                weap.DamageType = 'NormalBomb'
            end
        end
    end
end

--------------------------------------------------------------------------------
-- The bit that makes BrewLAN blueprints not care where BrewLAN is installed
--------------------------------------------------------------------------------

function BrewLANRelativisticLinksUpdate(all_bps)
    if BrewLANPath and BrewLANPath ~= "/mods/brewlan" then
        all_bps.Unit.saa0105.Desync = {
            "BrewLAN reports you installed it",
            "wrong; it should be at:",
            "/mods/brewlan",
            "but it's at:",
            BrewLANPath,
            "Everything should still work though.",
        }
        for id, bp in all_bps.Unit do
            if string.sub(bp.Source, 1, 13) == '/mods/brewlan' then
                PathTrawler(bp, "/mods/brewlan/", BrewLANPath .. "/" )
            end
        end
        for id, bp in all_bps.Beam do
            if string.sub(bp.Source, 1, 13) == '/mods/brewlan' then
                PathTrawler(bp, "/mods/brewlan/", BrewLANPath .. "/" )
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

function BrewLANMegalithEggs(id, bp, all_bps, Megalith, Egg000)
    --First check the Megalith exists and can build
    if Megalith and Megalith.Economy and Megalith.Economy.BuildableCategory and bp.Categories and HasCat(bp, 'MEGALITHEGG') then
        copyTableNoReplace(Egg000, bp)
        table.insert(Megalith.Economy.BuildableCategory, bp.BlueprintId)

        bp.BuildIconSortPriority = all_bps[bp.Economy.BuildUnit].BuildIconSortPriority
        bp.StrategicIconName = all_bps[bp.Economy.BuildUnit].StrategicIconName

        bp.Economy.BuildCostEnergy = all_bps[bp.Economy.BuildUnit].Economy.BuildCostEnergy
        bp.Economy.BuildCostMass = all_bps[bp.Economy.BuildUnit].Economy.BuildCostMass
        bp.Economy.BuildTime = all_bps[bp.Economy.BuildUnit].Economy.BuildTime

        bp.General.Icon = all_bps[bp.Economy.BuildUnit].General.Icon

        if bp.Size then
            bp.Footprint.SizeX = bp.Size
            bp.Footprint.SizeZ = bp.Size
            bp.SizeX = bp.Size
            bp.SizeY = bp.Size
            bp.SizeZ = bp.Size
            bp.Display.UniformScale = bp.Display.UniformScale * bp.Size
            bp.LifeBarOffset = bp.LifeBarOffset * bp.Size
            bp.LifeBarSize = bp.Size
            bp.SelectionSizeX = 0.65 * bp.Size
            bp.SelectionSizeZ = 0.65 * bp.Size
        end

        if all_bps[bp.Economy.BuildUnit].Physics.MotionType == 'RULEUMT_Hover'
        or all_bps[bp.Economy.BuildUnit].Physics.MotionType == 'RULEUMT_AmphibiousFloating' then
            bp.Physics.BuildOnLayerCaps = {
                LAYER_Land = true,
                LAYER_Water = true,
            }
        elseif all_bps[bp.Economy.BuildUnit].Physics.MotionType == 'RULEUMT_Amphibious' then
            bp.Physics.BuildOnLayerCaps = {
                LAYER_Land = true,
                LAYER_Seabed = true,
            }
        elseif all_bps[bp.Economy.BuildUnit].Physics.MotionType == 'RULEUMT_SurfacingSub'
        or all_bps[bp.Economy.BuildUnit].Physics.MotionType == 'RULEUMT_Water' then
            bp.Physics.BuildOnLayerCaps = {
                LAYER_Water = true,
            }
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

function BrewLANExtractFrozenMeshBlueprint(id, bp)
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
                        lod.SpecularName = BrewLANPath .. '/env/common/frozen_specular.dds'
                        lod.NormalsName = BrewLANPath .. '/env/common/frozen_normals.dds'
                    end
                end
            end
            frozenbp.BlueprintId = meshid .. '_frozen'
            bp.Display.MeshBlueprintFrozen = frozenbp.BlueprintId
            MeshBlueprint(frozenbp)
        end
    end
end

--------------------------------------------------------------------------------
-- Stuff for panopticon custom tab. Disabled currently because it didn't work for me.
--------------------------------------------------------------------------------

function BrewLANChangesForDominoModSupport(all_bps)
    --Disabled because I don't have a working version of Domino's to test.

    local modsuppport = false
    --[[for i, mod in __active_mods do
        if string.find(string.lower(mod.name),"domino mod support") then
            modsupport = true
            break
        end
    end]]

    if modsuppport and all_bps.seb3404 then
        for name, enh in all_bps.seb3404.Enhancements do
            if name == 'Slots' then
                enh.LCH = nil
                enh.Array = {
        			name = '<LOC _Array>',
        			x = 5,
        			y = 10,
        		}
            else
                enh.Slot = 'Array'
            end
        end
    end
end


--------------------------------------------------------------------------------
-- Generate footprint dummies for dealing with path blocking.
--------------------------------------------------------------------------------

function BrewLANGenerateFootprintDummyUnits(all_units)
    --These are used by the Aeon teleporter.
    --But also by the mines and any unit that wants to clear it's path blocking.
    local NewDummies = {}

    for id, bp in all_units do
        if bp.Physics.MotionType == 'RULEUMT_None' then
            local X = math.ceil(bp.Footprint.SizeX or bp.SizeX or 1)
            local Z = math.ceil(bp.Footprint.SizeZ or bp.SizeZ or 1)
            local SOX = bp.Physics.SkirtOffsetX or 0
            local SOZ = bp.Physics.SkirtOffsetZ or 0
            local SSX = bp.Physics.SkirtSizeX or 1
            local SSZ = bp.Physics.SkirtSizeZ or 1
            local OR = bp.Physics.OccupyRects

            local dummyID = 'ZZZFD'..X..Z..SOX..SOZ..SSX..SSZ

            if OR then
                for i, v in OR do
                    dummyID = dummyID..v
                end
            end

            if not NewDummies[dummyID] then
                NewDummies[dummyID] = {
                    BlueprintId = dummyID,
                    BuildIconSortPriority = 5,
                    Categories = {
                        'INVULNERABLE',
                        'STRUCTURE',
                        'BENIGN',
                        'UNSELECTABLE',
                        'UNTARGETABLE',
                        'UNSPAWNABLE',
                    },
                    Defense = {Health = 0, MaxHealth = 0},
                    Description = 'Footprint Dummy Unit',
                    Display = {
                        BuildMeshBlueprint = BrewLANPath .. '/meshes/nil_mesh',
                        MeshBlueprint = BrewLANPath .. '/meshes/nil_mesh',
                        UniformScale = 0,
                        HideLifebars = true,
                    },
                    Footprint = {SizeX = X, SizeZ = Z},
                    Economy = {
                        BuildCostEnergy = 1,
                        BuildCostMass = 1,
                        BuildTime = 1,
                    },
                    General = {CapCost = 0},
                    Intel = {
                        VisionRadius = 0,
                        WaterVisionRadius = 0,
                    },
                    Physics = {
                        BuildOnLayerCaps = {
                            LAYER_Land = true,
                            LAYER_Seabed = true,
                            LAYER_Water = true,
                        },
                        SkirtOffsetX = SOX,
                        SkirtOffsetZ = SOZ,
                        SkirtSizeX = SSX,
                        SkirtSizeZ = SSZ,
                        MotionType = 'RULEUMT_None',
                        OccupyRects = OR,
                    },
                    ScriptClass = 'BrewLANFootprintDummyUnit',
                    ScriptModule = '/lua/defaultunits.lua',
                    SizeX = X,
                    SizeY = 1,
                    SizeZ = Z,
                    Source = all_units.sab5401.Source,
                }

                SPEW("Creating footprint dummy unit: " .. dummyID)
            end
            bp.FootprintDummyId = dummyID
        end
    end
    -- Separate loop to prevent iterator issues.
    for id, bp in NewDummies do
        all_units[id] = bp
    end
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------

end
