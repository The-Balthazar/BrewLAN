--------------------------------------------------------------------------------
-- Supreme Commander mod automatic unit wiki generation script for Github wikis
-- By Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Inputs:

-- Note the following files within referenced mods must be valid Lua
-- /mod_info.lua
-- /hook/lua/ui/help/unitdescription.lua
-- /hook/loc/US/strings_db.lua

-- The output directory for the files, expected to be a clone of a Github wiki repo, but not asserted such
local WikiRepoDir = "C:/BrewLAN.wiki"

-- The input list of mod directories to create pages for
-- It will recusively search for bp files with the following criteria:
--  - The blueprints must be somewhere within '/units'
--    - This is to reduce the amount of time it spends directory searching, which is the slowest part
--  - The blueprint filenames must end in '_unit.bp'
--  - The blueprint filenames must not begin with 'z' or 'Z'
--  - The blueprint files MUST be valid lua. That means not using # for comment.
local ListOfModDirectories = {
    'C:/BrewLAN/mods/BrewLAN',
    'C:/BrewLAN/mods/BrewLAN_Units/BrewAir',
    'C:/BrewLAN/mods/BrewLAN_Units/BrewIntel',
    'C:/BrewLAN/mods/BrewLAN_Units/BrewMonsters',
    'C:/BrewLAN/mods/BrewLAN_Units/BrewResearch',
    'C:/BrewLAN/mods/BrewLAN_Units/BrewShields',
    'C:/BrewLAN/mods/BrewLAN_Units/BrewTeaParty',
    'C:/BrewLAN/mods/BrewLAN_Units/BrewTurrets',
}

-- The location of the hard-coded wiki icons
-- This is used at the start of src values in img tags so it can be a web domain
-- However, it does assume the images it expects are right in there with the names it expects
local IconRepo = "/The-Balthazar/The-Balthazar.github.io/raw/master/BrewLAN-wiki/icons/"

-- The location of the unit icons for inclusion in the wiki
-- The files are expected to be [unit blueprintID]_icon.png
-- This doesn't have to be a sub-directory of the icon repo
local unitIconRepo = IconRepo.."units/"

--------------------------------------------------------------------------------

local sidebarData = {}
local categoryData = {}

--------------------------------------------------------------------------------
-- The beans
function MakeWiki(moddir, modsidebarindex)

    local bdir = moddir.."/units"--"C:/BrewLAN"
    local modname
    local modinfo = {}
    do
        local pass, msg = dofile(moddir..'/mod_info.lua')
        modname = name
        modinfo.description = description
        modinfo.author = author
        modinfo.version = version
    end

    ----------------------------------------------------------------------------
    local bpdirlist = {} -- list of strings
    Description = {} -- To load the build description lists
    local dirsearch
    dirsearch = function(dir, p)
        for line in io.popen('dir "'..dir..'" /b '..(p or '')):lines() do
            if string.sub(line, 1, 1) ~= '.' then -- filter out .git and other .folders
                if string.sub(line,-8,-1) == '_unit.bp' and string.sub(line,1,1) ~= 'Z' and string.sub(line,1,1) ~= 'z' then
                    table.insert(bpdirlist, {dir,line})
                    --print(dir..'/'..line)
                else
                    dirsearch(dir..'/'..line)
                end
            end
        end
    end

    ----------------------------------------------------------------------------
    local arrayfind = function(array, str)
        if not array then return end
        for i, v in ipairs(array) do
            if v == str then
                return i
            end
        end
    end
    local arraySubfind = function(array, str)
        if not array then return end
        for i, v in ipairs(array) do
            if string.find(v, str) then
                return v
            end
        end
    end

    ----------------------------------------------------------------------------
    local iconText = function(icon, text, text2)
        --icon = string.lower(icon)
        local icons = {
            Health = IconRepo..'health.png',
            Regen = IconRepo..'health.png',
            Shield = IconRepo..'shield.png',

            Energy = IconRepo..'energy.png',
            Mass = IconRepo..'mass.png',
            Time = IconRepo..'time.png',

            Build = IconRepo..'build.png',

            Fuel = IconRepo..'fuel.png',
            Attached = IconRepo..'attached.png',
        }
        if icons[icon] and text then
            return '<img src="'..icons[icon]..'" title="'..icon..'" /> '..text..(text2 or '')
        elseif text then
            return text..(text2 or '')
        end
    end

    ----------------------------------------------------------------------------
    local LOC = function(s)
        if type(s) == 'string' and string.sub(s, 1, 4)=='<LOC' then
            local i = string.find(s,">")
            local locK = string.sub(s, 6, i-1)
            if _G[locK] then
                return _G[locK]
            else
                return string.sub(s, i+1)
            end
        end
        return s
    end

    ----------------------------------------------------------------------------
    local Layers = {
        Land = 1,
      Seabed = 2,
         Sub = 4,
       Water = 8,
         Air = 16,
    }

    -- Motion types mapped to plain text string descriptions, and layers they relevantly be firing from.
    local motionTypes = {
        RULEUMT_Air                = {'aircraft',   {Air = 16}},
        RULEUMT_Amphibious         = {'seabed amphibious',   {Land = 1, Seabed = 2           }},
        RULEUMT_AmphibiousFloating = {'floating amphibious', {Land = 1,             Water = 8}},
        RULEUMT_Biped              = {'land',                {Land = 1                       }},
        RULEUMT_Land               = {'land',                {Land = 1                       }},
        RULEUMT_Hover              = {'hover',               {Land = 1,             Water = 8}},
        RULEUMT_Water              = {'naval',               {                      Water = 8}},
        RULEUMT_SurfacingSub       = {'submarine',  {Sub = 4,                       Water = 8}},
        RULEUMT_None               = {'structure',  {Sub = 4, Land = 1, Seabed = 2, Water = 8}},
        --RULEUMT_Special            = {'',{}}, -- Defined in the engine, but reports malformed if you try to use it
    }

    local IsDeathWeapon = function(wep)
        return (wep.Label == 'DeathWeapon' or wep.Label == 'DeathImpact' or wep.WeaponCategory == 'Death')
    end

    local bitcombine = function(asdf)
        local asd = 0
        for i, v in pairs(asdf) do
            asd = asd + v
        end
        return asd
    end

    local GetTargetLayers = function(weapon, unit)
        local fromLayers = motionTypes[unit.Physics.MotionType][2]
        local targetLayers = {}
        if weapon.FireTargetLayerCapsTable then
            for layer, targetstring in pairs(weapon.FireTargetLayerCapsTable) do
                if fromLayers[layer] then
                    --Reusing the layer reference here, because we don't need the other one again.
                    for layer, bit in pairs(Layers) do
                        if string.find(targetstring, layer) then
                            targetLayers[layer] = bit
                        end
                    end
                end
            end
        end
        if weapon.AboveWaterTargetsOnly then
            targetLayers.Sub = nil
            targetLayers.Seabed = nil
        end
        return targetLayers, bitcombine(targetLayers)
    end

    local WepTarget = function(weapon, unit)
        if IsDeathWeapon(weapon) then
            return nil
        end

        if weapon.TargetType == 'RULEWTT_Projectile' then
            local s = '<code>'..weapon.TargetType..'</code>'
            local mapping = {
                {'STRATEGIC', '(Anti-strategic)'},
                { 'TACTICAL', '(Anti-tactical)'},
                {  'MISSILE', '(Anti-missile)'},
                {  'TORPEDO', '(Anti-torpedo)'},
            }
            for i, cats in ipairs(mapping) do
                if (weapon.TargetRestrictOnlyAllow == cats[1] or string.find(weapon.TargetRestrictOnlyAllow, cats[1])) then
                    return s..'<br />'..cats[2]
                end
            end
            return s

        elseif weapon.TargetType == 'RULEWTT_Prop' then
            return '<code>'..weapon.TargetType..'</code><error:prop weapon;its a real thing but why>'

        else --'RULEWTT_Unit' is the default and generally not written
            local s = '<code>RULEWTT_Unit</code>'

            if weapon.TargetRestrictOnlyAllow and (weapon.TargetRestrictOnlyAllow == 'AIR' --[[or string.find(weapon.TargetRestrictOnlyAllow, 'AIR')]]) then
                return s .. '<br />(Anti-Air)'
            end

            local targetLayers, bitwiselayers = GetTargetLayers(weapon, unit)

            if bitwiselayers == 0 then
                return 'Untargeted'
            end

            --Note seabed and sub have been filtered out of 'above water target only' weapons
            local bitmap = {
                [1] = 'Anti-Land',  --land
                [2] = 'Anti-Seabed',  --seabed
                [3] = 'Anti-Terrain', --land seabed
                [4] = 'Anti-Submarine',  --sub
                [5] = 'Anti-Land &amp; Sub', --land and sub
                [6] = 'Anti-Underwater',  --seabed sub
                [7] = 'Anti-Land &amp; Underwater', --land seabed sub
                [8] = 'Anti-Ship',  -- water
                [9] = 'Anti-Surface',  --land water
                [10] = 'Anti-Ship &amp; Seabed', --seabed water
                [11] = 'Anti-Ship, Seabed, &amp; Land',--seabed water land
                [12] = 'Anti-Ship &amp; Sub', --water sub
                [13] = 'Anti-Surface &amp; Sub', --water sub land
                [14] = 'Anti-Naval', --water sub seabed
                [15] = 'Anti-Land &amp; Naval', --water sub seabed land
                [16] = 'Anti-Air',
                --[17] = 'error:something with air',
            }

            local lowAltAir

            if bitwiselayers >= 16 and (weapon.TargetRestrictDisallow and string.find(weapon.TargetRestrictDisallow, 'HIGHALTAIR')) then
                lowAltAir = 'Low-Altidude Anti-Air'
                bitwiselayers = bitwiselayers - 16
            end

            if bitwiselayers > 16 then
                return s..'<error:Weapon hits high alt air and other stuff>'
            end

            return s..'<br />('..(bitmap[bitwiselayers] and bitmap[bitwiselayers]..(lowAltAir and ', '..lowAltAir or '') or lowAltAir)..')'

        end
    end

    local WepProjectiles = function(weapon, unit)
        if not weapon.RackBones then return end
        local ProjectileCount
        if weapon.MuzzleSalvoDelay == 0 then
            ProjectileCount = math.max(1, #(weapon.RackBones[1].MuzzleBones or {'boop'} ) )
        else
            ProjectileCount = (weapon.MuzzleSalvoSize or 1)
        end
        if weapon.RackFireTogether then
            ProjectileCount = ProjectileCount * math.max(1, #(weapon.RackBones or {'boop'} ) )
        end
        return ProjectileCount
    end

    local DPSEstimate = function(weapon, unit)
        -- Dont do death weapons, or weapons without RoF
        if IsDeathWeapon(weapon) or not weapon.RateOfFire then
            return
        end
        -- Only do unit weapons, not projectile or the technically real but not really 'prop' weapons
        if not (weapon.TargetType == 'RULEWTT_Unit' or not weapon.TargetType) then
            return
        end

        local damage = (weapon.NukeInnerRingDamage or weapon.Damage)
        * (WepProjectiles(weapon, unit) or 1)
        * math.max(weapon.DoTPulses or 1, 1)

        if (weapon.BeamLifetime and weapon.BeamLifetime > 0) and weapon.BeamCollisionDelay then
            damage = damage * math.ceil( (weapon.BeamLifetime or 1) / (weapon.BeamCollisionDelay + 0.1) )
        end

        --NeedToComputeBombDrop -- ROF isn't important to bombers

        local rof

        if weapon.RateOfFire and not (weapon.BeamLifetime == 0 and weapon.BeamCollisionDelay) then
            rof = 1 / (math.floor(10 / weapon.RateOfFire + 0.5)/10)

            local chargeRof = 10
            if weapon.EnergyRequired and weapon.EnergyDrainPerSecond then
                chargeRof = 1 / (math.floor((weapon.EnergyRequired / weapon.EnergyDrainPerSecond) * 10)/10)
            end
            rof = math.min(rof, chargeRof, 10)
        end

        if (weapon.BeamLifetime == 0 and weapon.BeamCollisionDelay) then
            rof = 1 / ((weapon.BeamCollisionDelay or 0) + 0.1)
        end

        return math.floor(damage * rof + 0.5)
    end
    ----------------------------------------------------------------------------
    local abilityDesc = {
        ['Anti-Air'] = 'Can shoot aircraft, including high-altitude air',
        ['Air Staging'] = 'Aircraft can land on it for refuel and/or repair',
        ['Artillery Defense'] = 'Protects against artillery projectile weapons',
        ['Amphibious'] = 'Can pass land and water',
        ['Aquatic'] = 'Buildable on land and on or in water',
        ['Carrier'] = 'Can build and/or store aircraft',
        ['Cloaking'] = 'Can become hidden to visual sensors',
        ['Customizable'] = 'Has optional enhancements to improve performance or unlock new featuers',
        ['Directional Sensor'] = 'Has non-standard intel that is off-centre', -- BrewLAN
        ['Volatile'] = 'Has a death weapon',
        ['Deploys'] = 'Needs to be stationary for one or more effects',
        ['Depth Charges'] = 'Can attack water with projectiles immune to anti-torpedo',
        ['Engineering Suite'] = 'Has complete engineering features',
        ['Factory'] = 'Can build units without entering command mode',
        ['Hover'] = 'Can pass water and is immune to torpedoes',
        ['Jamming'] = 'Creates false radar signals',
        ['Manual Launch'] = 'Has a counted projectile weapon that needs manually controlling',
        ['Massive'] = 'Damages things by treading on them',
        ['Missile Defense'] = 'Has countermeasures for missiles that don\'t count as \'tactical\' or \'strategic\'', -- BrewLAN
        ['Not Capturable'] = 'Is either unable to be, or never in a position to be, captured',
        ['Omni Sensor'] = 'Has advanced intel that can see through counterintel',
        ['Personal Shield'] = 'Has a shield that only effectively protects itself',
        ['Personal Stealth'] = 'Hidden to radar and/or sonar',
        ['Personal Teleporter'] = 'Has the ability to teleport without requiring an enhancement', -- BrewLAN
        ['Radar'] = 'Can see blips of units not seen by vision that are on or above water',
        ['Reclaims'] = 'Can harvest entities for resources; this damages them if they have health',
        ['Repairs'] = 'Can fix damage on other units at the cost of resources',
        ['Sacrifice'] = 'Can destroy itself to contribute to a build',
        ['Satellite Uplink'] = 'Prevents satellites from receiving damage from flying unguided',  -- BrewLAN
        ['Satellite Capacity: +0'] = 'Doesn\'t contribute towards satellite population capacity',-- BrewLAN
        ['Satellite Capacity: +1'] = 'Contributes 1 towards the maximum deployable satellites',  -- BrewLAN
        ['Satellite Capacity: +2'] = 'Contributes 2 towards the maximum deployable satellites',  -- BrewLAN
        ['Satellite Capacity: +3'] = 'Contributes 3 towards the maximum deployable satellites',  -- BrewLAN
        ['Satellite Capacity: +4'] = 'Contributes 4 towards the maximum deployable satellites',  -- BrewLAN
        ['Satellite Capacity: +5'] = 'Contributes 5 towards the maximum deployable satellites',  -- BrewLAN
        ['Satellite Capacity Unrestricted'] = 'Effectively removes satellite deployment limits', -- BrewLAN
        ['Shield Dome'] = 'Has a bubble shield that can protect others',
        ['Sonar'] = 'Can see blips of units not seen by vision that are on or below water',
        ['Stealth Field'] = 'Hides itself and nearby others from radar and/or sonar',
        ['Strategic Missile Defense'] = 'Can target strategic missile projectiles',
        ['EMP Weapon'] = "Can inflict 'stun'",
        ['Submersible'] = 'Is a naval unit that can surface and dive',
        ['Suicide Weapon'] = 'Has a single-use self-damaging weapon',
        ['Tactical Missiles'] = 'Has a weapon with projectiles that identify as tactical missiles', -- BrewLAN
        ['Tactical Missile Defense'] = 'Can target tactical missile projectiles',
        ['Tactical Missile Deflection'] = 'Can target and redirect tactical missile projectiles',
        ['Teleporter'] = 'Can teleport itself and others', -- BrewLAN
        ['Torpedoes'] = 'Has a weapon that can target things immersed in water',
        ['Torpedo Defense'] = 'Can target torpedo projectiles',
        ['Transport'] = 'Can carry other units',
        ['Upgradeable'] = 'Can build a unit to replace itself',
    }
    local abilityTitle = function(ability)
        return '<span title="'..(abilityDesc[ability] or 'error:description')..'" >'..ability..'</span>'
    end

    local BuildableLayer = function(phys)
        --This script assumes it's a structure. This doesn't matter to non-structures.
        if not phys.BuildOnLayerCaps then
            return 'Land'
        else
            local str = ''
            for key, val in pairs(phys.BuildOnLayerCaps) do
                if val then
                    str = str..string.sub(key, 7)..'<br />'
                end
            end
            return str
        end
    end

    local buildercats = {
        BUILTBYTIER1FIELD            = {'Tech 1 Field Engineer',           5},  -- BrewLAN
        BUILTBYTIER2FIELD            = {'Tech 2 Field Engineer',           10}, -- BrewLAN
        BUILTBYTIER3FIELD            = {'Tech 3 Field Engineer',           15}, -- BrewLAN
        BUILTBYENGINEER              = {'Tech 1 Engineer',                 5},  -- R&D
        BUILTBYTIER1ENGINEER         = {'Tech 1 Engineer',                 5},
        BUILTBYTIER2ENGINEER         = {'Tech 2 Engineer',                 10},
        BUILTBYTIER3ENGINEER         = {'Tech 3 Engineer',                 15},
        BUILTBYCOMMANDER             = {'Armoured Command Unit',           10},
        BUILTBYTIER2COMMANDER        = {'Tech 2 Armoured Command Unit',    30},
        BUILTBYTIER3COMMANDER        = {'Tech 3 Armoured Command Unit',    90},
        BUILTBYTIER1FACTORY          = {'Tech 1 Factory',                  20},
        BUILTBYTIER2FACTORY          = {'Tech 2 Factory',                  40},
        BUILTBYTIER3FACTORY          = {'Tech 3 Factory',                  60},
        BUILTBYLANDTIER1FACTORY      = {'Tech 1 Land Factory',             20}, -- BrewLAN
        BUILTBYLANDTIER2FACTORY      = {'Tech 2 Land Factory',             40},
        BUILTBYLANDTIER3FACTORY      = {'Tech 3 Land Factory',             60}, -- BrewLAN
        BUILTBYTIER1SURFACEFACTORY   = {'Tech 1 Amphibious Factory',       20}, -- R&D
        BUILTBYTIER2SURFACEFACTORY   = {'Tech 2 Amphibious Factory',       40}, -- R&D
        BUILTBYTIER3SURFACEFACTORY   = {'Tech 3 Amphibious Factory',       60}, -- R&D
        BUILTBYQUANTUMGATE           = {'Tech 3 Quantum Gateway',          120},
        TRANSPORTBUILTBYTIER3FACTORY = {'Tech 3 Air Factory',              60},
        BUILTBYTIER3SPACEPORT        = {'Tech 3 Satellite Launch Complex', 100}, -- BrewLAN
        BUILTBYHEAVYWALL             = {'Tech 3 Armored Wall Segment',     1},   --BrewLAN
        BUILTBYGANTRY                = {'Experimental Factory',            240}, -- BrewLAN
        BUILTBYEXPERIMENTALSUB       = nil, -- Referenced in vanilla, but nothing uses this
    }

    local BuilderList = function(bp)
        --local builders = {}
        --local cathash = {}
        local bilst = ''

        if not bp.Economy then return 'error:no eco table' end
        if not bp.Economy.BuildCostEnergy then return 'error:no build cost e' end
        if not bp.Economy.BuildCostMass then return 'error:no build cost m' end
        if not bp.Economy.BuildTime then return 'error:no build time' end

        for i, cat in ipairs(bp.Categories) do
            --cathash[cat] = string.find(cat, 'BUILTBY') and true or nil
            if buildercats[cat] then
                --table.insert(builders, )
                local secs = bp.Economy.BuildTime / buildercats[cat][2]
                bilst = bilst .. [[
* ]]..iconText('Time', string.format('%02d:%02d', math.floor(secs/60), math.floor(secs % 60) ) )..' ‒ '..iconText('Energy', math.floor(bp.Economy.BuildCostEnergy / secs + 0.5), '/s')..' ‒ '..iconText('Mass', math.floor(bp.Economy.BuildCostMass / secs + 0.5), '/s')..' — Built by '..buildercats[cat][1]..[[

]]
            elseif string.find(cat, 'BUILTBY') then
                bilst = bilst..[[
* <error:category />Unknown build category <code>]]..cat..[[</code>

]]
            end
        end


        return bilst
    end

    ----------------------------------------------------------------------------
    print("Finding unit blueprint files")
    dirsearch(bdir, '/ad')
    print("Found "..#bpdirlist.." blueprint files")
    print("Loading build descriptions")
    do
        local pass, msg = pcall(dofile, moddir..'/hook/lua/ui/help/unitdescription.lua')
        if pass then print("Build descriptions loaded")
        else print(msg) end
    end
    do
        print("Loading loc strings")
        local pass, msg = pcall(dofile, moddir..'/hook/loc/US/strings_db.lua')
        if pass then print("LOC strings loaded")
        else print(msg) end
    end
    print("Creating wiki pages")
    for i, fdir in ipairs(bpdirlist) do
        local bp
        ----------------------------------------------------------------------------
        UnitBlueprint = function(a) bp = a end
        Sound = function(a) return a end
        ----------------------------------------------------------------------------
        local pass, msg = pcall(dofile, fdir[1]..'/'..fdir[2])
        if not pass then print(msg)
        --else print(bp)
        end
        ----------------------------------------------------------------------------
        --local bp = all_bps[fdir[2]]
        local bpid = string.sub(fdir[2],1,-9)
        print(bpid)
        ----------------------------------------------------------------------------
        local md = io.open(WikiRepoDir..'/'..bpid..'.md', "w")

        local unitTdesc = LOC(bp.Description)
        local unitTlevel

        if arrayfind(bp.Categories, 'EXPERIMENTAL') then
            unitTlevel = 'Experimental'
        else
            for i = 1, 3 do
                if arrayfind(bp.Categories, 'TECH'..i) then
                    unitTlevel = 'Tech '..i
                    unitTdesc = unitTlevel..' '..LOC(bp.Description)
                    break
                end
            end
        end

        local infoboxdata = {
            {'', "Note: Several units have stats defined at the<br />start of the game based on the stats of others."},
            {'Source:', '<a href="'..string.gsub(modname, ':', '')..'">'..modname..'</a>'},
            {'Unit ID:', '<code>'..string.lower(bpid)..'</code>',},
            {'Faction:', (bp.General and bp.General.FactionName)},
            {''},
            {'Health:',
                (
                    not arrayfind(bp.Categories, 'INVULNERABLE')
                    and iconText(
                        'Health',
                        bp.Defense.MaxHealth,
                        (bp.Defense.RegenRate and ' (+'..bp.Defense.RegenRate ..'/s)')
                    )
                    or 'Invulnerable'
                )
            },
            --{'Regen:', (not arrayfind(bp.Categories, 'INVULNERABLE') and iconText('Health', bp.Defense.RegenRate, '/s'))},
            {'Armour:', (not arrayfind(bp.Categories, 'INVULNERABLE') and bp.Defense.ArmorType and '<code>'..bp.Defense.ArmorType..'</code>')},
            {'Shield health:',
                iconText(
                    'Shield',
                    bp.Defense.Shield and bp.Defense.Shield.ShieldMaxHealth,
                    (bp.Defense.Shield and bp.Defense.Shield.ShieldRegenRate and ' (+'..bp.Defense.Shield.ShieldRegenRate..'/s)')
                )
            },
            --{'Shield regen:', iconText('shield', bp.Defense.Shield and bp.Defense.Shield.ShieldRegenRate, '/s')},
            {'Shield radius:', (bp.Defense.Shield and bp.Defense.Shield.ShieldSize)},
            {'Flags:',
                (
                    arrayfind(bp.Categories, 'UNTARGETABLE') or
                    arrayfind(bp.Categories, 'UNSELECTABLE') or
                    (bp.Display and bp.Display.HideLifebars or bp.LifeBarRender == false) or
                    (bp.Defense and bp.Defense.Shield and (bp.Defense.Shield.AntiArtilleryShield or bp.Defense.Shield.PersonalShield))
                ) and
                (arrayfind(bp.Categories, 'UNTARGETABLE') and 'Untargetable<br />' or '')..
                (arrayfind(bp.Categories, 'UNSELECTABLE') and 'Unselectable<br />' or '')..
                ((bp.Display and bp.Display.HideLifebars or bp.LifeBarRender == false) and 'Lifebars hidden<br />' or '' )..
                (bp.Defense and bp.Defense.Shield and bp.Defense.Shield.AntiArtilleryShield and 'Artillery shield<br />' or '')..
                (bp.Defense and bp.Defense.Shield and bp.Defense.Shield.PersonalShield and 'Personal shield<br />' or '')
            },
            {''},
            {'Energy cost:', iconText('Energy', bp.Economy and bp.Economy.BuildCostEnergy)},
            {'Mass cost:', iconText('Mass', bp.Economy and bp.Economy.BuildCostMass)},
            {'Build time:', iconText('Time-but-not', bp.Economy and bp.Economy.BuildTime, ' (<a href="#construction">Details</a>)')}, --I don't like the time icon for this, it looks too much and it's also not in real units
            {'Maintenance cost:', iconText('Energy', bp.Economy and bp.Economy.MaintenanceConsumptionPerSecondEnergy,'/s')},
            --{''},
            {'Build rate:', iconText('Build', bp.Economy and bp.Economy.BuildRate)},
            {'Energy production:', iconText('Energy', bp.Economy and bp.Economy.ProductionPerSecondEnergy, '/s')},
            {'Mass production:', iconText('Mass', bp.Economy and bp.Economy.ProductionPerSecondMass, '/s')},
            {'Energy storage:', iconText('Energy', bp.Economy and bp.Economy.StorageEnergy)},
            {'Mass storage:', iconText('Mass', bp.Economy and bp.Economy.StorageMass)},
            {''},
            {'Vision radius:', (bp.Intel and bp.Intel.VisionRadius or 10)},
            {'Water vision radius:', (bp.Intel and bp.Intel.WaterVisionRadius or 10)},
            {'Radar radius:', (bp.Intel and bp.Intel.RadarRadius)},
            {'Sonar radius:', (bp.Intel and bp.Intel.SonarRadius)},
            {'Omni radius:', (bp.Intel and bp.Intel.OmniRadius)},
            {'Jammer blips (radii):',
                (bp.Intel and bp.Intel.JamRadius)
                and
                (bp.Intel.JammerBlips or 0)..' ('..
                (bp.Intel.JamRadius.Min)..'‒'..
                (bp.Intel.JamRadius.Max)..')'
            },
            {'Cloak radius:', (bp.Intel and bp.Intel.CloakFieldRadius)},
            {'Radar stealth radius:', (bp.Intel and bp.Intel.RadarStealthFieldRadius)},
            {'Sonar stealth radius:', (bp.Intel and bp.Intel.SonarStealthFieldRadius)},
            {'Flags:',
                (bp.Intel and (bp.Intel.Cloak or bp.Intel.RadarStealth or bp.Intel.SonarStealth))
                and
                (bp.Intel.Cloak and 'Cloak<br />' or '')..
                (bp.Intel.RadarStealth and 'Radar stealth<br />' or '')..
                (bp.Intel.SonarStealth and 'Sonar stealth<br />' or '')
            },
            {''},
            {'Motion type:', bp.Physics.MotionType and ('<code>'..bp.Physics.MotionType..'</code>')},
            {'Buildable layers:', (bp.Physics.MotionType == 'RULEUMT_None') and BuildableLayer(bp.Physics)},
            {'Movement speed:', (bp.Air and bp.Air.MaxAirspeed or bp.Physics.MaxSpeed)},
            {'Fuel:', (bp.Physics.FuelUseTime and iconText('Fuel', string.format('%02d:%02d', math.floor(bp.Physics.FuelUseTime/60), math.floor(bp.Physics.FuelUseTime % 60)), '') )},
            {'Elevation:', (bp.Air and bp.Physics.Elevation)},
            {'Transport class:', (
                (
                    bp.Physics.MotionType ~= 'RULEUMT_None' and (
                        bp.General and bp.General.CommandCaps and (
                            bp.General.CommandCaps.RULEUCC_CallTransport or bp.General.CommandCaps.RULEUCC_Dock
                        )
                    )
                ) and iconText('Attached',
                    bp.Transport and bp.Transport.TransportClass or 1
                )
            ), 'The space this occupies on transports or on air staging. No units can accommodate greater than class 3.'},
            {'Class 1 capacity:', iconText('Attached', bp.Transport and bp.Transport.Class1Capacity), 'The number of class 1 units this can carry. For class 2 and 3 estimates, half or quarter this number; actual numbers will vary on how the attach points are arranged.'},
            {''},
            {'Misc radius:', arrayfind(bp.Categories, 'OVERLAYMISC') and bp.AI and bp.AI.StagingPlatformScanRadius, 'Defined by the air staging radius value. Often used to indicate things without a dedicated range rings.' },
            {'Weapons:', bp.Weapon and #bp.Weapon..' (<a href="#weapons">Details</a>)'},
        }


        local infoboxstring = [[
<table align=right>
    <thead>
        <tr>
            <th colspan='2' align=left>
                <img align="left" title="]]..(LOC(bp.General.UnitName) or 'The')..[[ unit icon" src="]]..unitIconRepo..bpid..[[_icon.png" />
                ]]..(LOC(bp.General.UnitName) or '<i>Unnamed</i>')..[[<br />
                ]]..(unitTdesc or [[<i>No description</i>]])..[[

            </th>
        </tr>
    </thead>
    <tbody>
]]

        for i, field in ipairs(infoboxdata) do
            if field[1] == '' then
                infoboxstring = infoboxstring .. [[
        <tr><td colspan='2' align=center>]]..(field[2] or '')..[[</td></tr>
]]
            elseif field[2] then
                infoboxstring = infoboxstring .. [[
        <tr>
            <td align=right><strong>]]..field[1]..[[</strong></td>
            <td>]]..field[2]
                if field[3] then
                    infoboxstring = infoboxstring..' <span title="'..field[3]..'">(<u>?</u>)</span>'
                end
                infoboxstring = infoboxstring .. [[</td>
        </tr>
]]
            end
        end

        infoboxstring = infoboxstring .. [[
    </thead>
</table>

]]

        local headerstring = (bp.General.UnitName and '"'..LOC(bp.General.UnitName)..'": ' or '')..unitTdesc..[[

----
]]


        local bodytext = (bp.General.UnitName and '"'..LOC(bp.General.UnitName)..'" is a'
        or 'This unamed unit is a')..(bp.General and bp.General.FactionName == 'Aeon' and 'n ' or ' ') -- a UEF, an Aeon ect.
        ..(bp.General and bp.General.FactionName..' ')..(bp.Physics.MotionType and motionTypes[bp.Physics.MotionType][1] or 'structure')..' unit included in *'..modname..[[*.
]]..(unitTdesc and 'It is classified as a '..string.lower(unitTdesc) or 'It is an unclassified'..(unitTlevel and ' '..string.lower(unitTlevel) ) )..' unit'..(not unitTlevel and ' with no defined tech level' or '')..'.'

        if Description[string.lower(bpid)] then
            bodytext = bodytext..[[

The build description for this unit is:

<blockquote>]]..LOC(Description[string.lower(bpid)])..[[</blockquote>
]]
        else
            bodytext = bodytext..[[ It has no defined build description.
]]
        end

        if bp.Display and bp.Display.Abilities and #bp.Display.Abilities > 0 then
            bodytext = bodytext..[[

### Abilities
Hover over abilities to see effect descriptions.]]
            for i, ability in ipairs(bp.Display.Abilities) do
                bodytext = bodytext..[[

* ]]..abilityTitle(LOC(ability))..[[
]]
            end
            bodytext = bodytext..[[

]]
        end

        local sizecat = arraySubfind(bp.Categories, 'SIZE')
        local sizecatno = sizecat and tonumber(string.sub(sizecat,5))

        local sizeX = math.max(bp.Footprint and bp.Footprint.SizeX or bp.SizeX or 1, bp.Physics.SkirtSizeX or 0)
        if math.floor(bp.Physics.SkirtOffsetX or 0) ~= (bp.Physics.SkirtOffsetX or 0) - 0.5 then sizeX = sizeX - 1 end
        sizeX = math.floor(sizeX / 2) * 2

        local sizeZ = math.max(bp.Footprint and bp.Footprint.SizeZ or bp.SizeZ or 1, bp.Physics.SkirtSizeZ or 0)
        if math.floor(bp.Physics.SkirtOffsetZ or 0) ~= (bp.Physics.SkirtOffsetZ or 0) - 0.5 then sizeZ = sizeZ - 1 end
        sizeZ = math.floor(sizeZ / 2) * 2

        local actualsize = math.max(2, sizeX) + math.max(2, sizeZ)

        if sizecat or bp.Adjacency then
            bodytext = bodytext..[[

### Adjacency
]]..(sizecat and "This unit counts as `"..
            sizecat.."` for adjacency effects from other structures. This theoretically means that it can be surrounded by exactly "..
            string.sub(sizecat,5).." structures the size of a standard tech 1 power generator"..(
            actualsize and (
                actualsize == sizecatno
                and ', which is accurate; meaning it can get the maximum intended buff effects'
                or actualsize > sizecatno
                and ', however it is actually larger; meaning it receives '..string.format('%.1f', (actualsize / sizecatno - 1) * 100)..'% better buffs than would normally be afforded it'
                or actualsize < sizecatno
                and ', however it is actually smaller; meaning it receives '..string.format('%.1f', (1 - actualsize / sizecatno) * 100)..'% weaker buffs than a standard structure of the same skirt size'
            ) or '')..'. ' or '')

            if bp.Adjacency then
                bodytext = bodytext..[[The adjacency bonus `]]..bp.Adjacency..[[` is given by this unit.]]
            end
            bodytext = bodytext..[[

]]
        end

        if arraySubfind(bp.Categories, 'BUILTBY') then
            bodytext = bodytext..[[

### Construction
The estimated build times for this unit on the Steam/retail version of the game are as follows; Note: This only includes hard-coded builders; some build categories are generated on game launch.
]]..BuilderList(bp)..[[
]]
            -- ### Builders
        end

        if bp.Economy and bp.Economy.BuildRate and
        (
            bp.Economy.BuildableCategory or bp.General and bp.General.CommandCaps and
            (
                bp.General.CommandCaps.RULEUCC_Capture or
                bp.General.CommandCaps.RULEUCC_Reclaim or
                bp.General.CommandCaps.RULEUCC_Repair or
                bp.General.CommandCaps.RULEUCC_Sacrifice
            )
        )
        then
            -- ### Build options
            local eng = {}
            if bp.General and bp.General.CommandCaps then
                local eng2 = {
                    {'capture', bp.General.CommandCaps.RULEUCC_Capture},
                    {'reclaim', bp.General.CommandCaps.RULEUCC_Reclaim},
                    {'repair', bp.General.CommandCaps.RULEUCC_Repair},
                    {'sacrifice', bp.General.CommandCaps.RULEUCC_Sacrifice},
                }
                for i, v in ipairs(eng2) do
                    if v[2] then
                        table.insert(eng, v)
                    end
                end
            end
            bodytext = bodytext..[[

### Engineering

]]
            if #eng > 0 then
                bodytext = bodytext..'The engineering capabilties of this unit consist of the ability to '
                for i = 1, #eng do
                    bodytext = bodytext..eng[i][1]
                    if i < #eng then
                        bodytext = bodytext..', '
                    end
                    if i + 1 == #eng then
                        bodytext = bodytext..'and '
                    end
                    if i == #eng then
                        bodytext = bodytext..[[.
]]
                    end
                end
            end

            if bp.Economy.BuildableCategory then
                if #bp.Economy.BuildableCategory == 1 then
                    bodytext = bodytext..'It has the build category <code>'..bp.Economy.BuildableCategory[1]..[[</code>.
]]
                elseif #bp.Economy.BuildableCategory > 1 then
                    bodytext = bodytext..[[It has the build categories:
]]
                    for i, cat in ipairs(bp.Economy.BuildableCategory) do
                        bodytext = bodytext..[[
* <code>]]..cat..[[</code>
]]
                    end
                end
            end


        end




        if bp.Enhancements then
            bodytext = bodytext..[[

### Enhancements

]]
            local EnhacementsSorted = {}
            for key, enh in pairs(bp.Enhancements) do
                local SearchForRquisits
                SearchForRquisits = function(enhancements, req)
                    for key, enh in pairs(enhancements) do
                        if req == enh.Prerequisite then
                            table.insert(EnhacementsSorted, {key, enh})
                            SearchForRquisits(enhancements, key)
                        end
                    end
                end
                if not enh.Prerequisite then
                    table.insert(EnhacementsSorted, {key, enh})
                    SearchForRquisits(bp.Enhancements, key)
                end
            end
            for i, enh in ipairs(EnhacementsSorted) do
                local key = enh[1]
                local enh = enh[2]
                if key ~= 'Slots' and string.sub(key, -6, -1) ~= 'Remove' then
                    bodytext = bodytext..[[<details markdown="1">
<summary>]]..(enh.Name and LOC(enh.Name) or 'error:name')..[[</summary>
<p>
<table>
    <tr>
        <td align=right><strong>Description:</strong></td>
        <td>]]..(LOC(Description[string.lower(bpid..'-'..enh.Icon)]) or 'error:description')..[[</td>
    </tr>
    <tr>
        <td align=right><strong>Energy cost:</strong></td>
        <td>]]..iconText('Energy', enh.BuildCostEnergy or 'error:energy')..[[</td>
    </tr>
    <tr>
        <td align=right><strong>Mass cost:</strong></td>
        <td>]]..iconText('Mass', enh.BuildCostMass or 'error:mass')..[[</td>
    </tr>
    <tr>
        <td align=right><strong>Build time:</strong></td>
        <td>]]..iconText('Time', enh.BuildTime and bp.Economy and bp.Economy.BuildRate and math.ceil(enh.BuildTime / bp.Economy.BuildRate) or 'error:time')..[[ seconds</td>
    </tr>
    <tr>
        <td align=right><strong>Prerequisite:</strong></td>
        <td>]]..(enh.Prerequisite and LOC(bp.Enhancements[enh.Prerequisite].Name) or 'None')..[[</td>
    </tr>
</table>
</p>
</details>

]]
                end
            end
        end



        if bp.Weapon then
            bodytext = bodytext..[[

### Weapons

]]
            for i, wep in ipairs(bp.Weapon) do
                weapontable = {}
                table.insert(weapontable, {'Target type:', WepTarget(wep, bp)})
                table.insert(weapontable, {'DPS estimate:', DPSEstimate(wep, bp), "Note: This only counts listed stats."})
                table.insert(weapontable, {
                    'Damage:',
                    (wep.NukeInnerRingDamage or wep.Damage),
                    ( not (IsDeathWeapon(wep) and not wep.FireOnDeath) and "Note: This doesn't count additional scripted effects, such as splintering projectiles, and variable scripted damage.")
                })
                table.insert(weapontable, {'Damage to shields:', (wep.DamageToShields or wep.ShieldDamage) })
                table.insert(weapontable, {'Damage radius:', (wep.NukeInnerRingRadius or wep.DamageRadius)})
                table.insert(weapontable, {'Outer damage:', wep.NukeOuterRingDamage})
                table.insert(weapontable, {'Outer radius:', wep.NukeOuterRingRadius})
                do
                    local s = WepProjectiles(wep, bp)
                    if s and s > 1 then
                        if wep.BeamCollisionDelay then
                            s = tostring(s)..' beams'
                        else
                            s = tostring(s)..' projectiles'
                        end
                    else
                        s = ''
                    end
                    local dot = wep.DoTPulses
                    if dot and dot > 1 then
                        if s ~= '' then
                            s = s..'<br />'
                        end
                        s = s..dot.. ' DoT pulses'
                    end
                    if (wep.BeamLifetime and wep.BeamLifetime > 0) and wep.BeamCollisionDelay then
                        if s ~= '' then
                            s = s..'<br />'
                        end
                        s = math.ceil( (wep.BeamLifetime or 1) / (wep.BeamCollisionDelay + 0.1) )..' beam collisions'
                    end
                    if s == '' then s = nil end
                    table.insert(weapontable, {'Damage instances:', s})
                end
                table.insert(weapontable, {'Damage type:', wep.DamageType and '<code>'..wep.DamageType..'</code>'})
                table.insert(weapontable, {'Max range:', not IsDeathWeapon(wep) and wep.MaxRadius})
                table.insert(weapontable, {'Min range:', wep.MinRadius})
                if not IsDeathWeapon(wep) and wep.RateOfFire and not (wep.BeamLifetime == 0 and wep.BeamCollisionDelay) then
                    table.insert(weapontable, {
                        'Firing cycle:',
                        ('Once every '..tostring(math.floor(10 / wep.RateOfFire + 0.5)/10)..'s' ),
                        "Note: This doesn't count additional delays such as charging, reloading, and others."
                    })
                elseif not IsDeathWeapon(wep) and (wep.BeamLifetime == 0 and wep.BeamCollisionDelay) then
                    table.insert(weapontable, {
                        'Firing cycle:',
                        'Continuous beam<br />Once every '..((wep.BeamCollisionDelay or 0) + 0.1)..'s',
                        'How often damage instances occur.'
                    })
                end
                table.insert(weapontable, {'Firing cost:',
                    iconText(
                        'Energy',
                        wep.EnergyRequired and wep.EnergyRequired ~= 0 and
                        (
                            wep.EnergyRequired ..
                                (wep.EnergyDrainPerSecond and ' ('..wep.EnergyDrainPerSecond..'/s for '..(math.ceil((wep.EnergyRequired/wep.EnergyDrainPerSecond)*10)/10)..'s)' or '')
                            )
                        )
                    }
                )
                table.insert(weapontable, {'Flags:', (wep.ArtilleryShieldBlocks and 'Artillery <span title="Blocked by artillery shield">(<u>?</u>)</span>' or nil)})
                table.insert(weapontable, {'Projectile storage:', (wep.MaxProjectileStorage and (wep.InitialProjectileStorage or 0)..'/'..(wep.MaxProjectileStorage) )})
                if wep.Buffs then
                    local buffs = ''
                    for i, buff in ipairs(wep.Buffs) do
                        if buff.BuffType then
                            if buffs ~= '' then
                                buffs = buffs..'<br />'
                            end
                            buffs = buffs..'<code>'..buff.BuffType..'</code>'
                        end
                    end
                    if buffs == '' then
                        buffs = nil
                    end
                    table.insert(weapontable, {'Buffs:', buffs})
                end

                bodytext = bodytext..[[
<details markdown="1">
    <summary>]]..(wep.DisplayName or wep.Label or '<i>Dummy Weapon</i>')..[[</summary>
    <p>
    <table>
]]
                for i, data in ipairs(weapontable) do
                    if data[2] then
                    bodytext = bodytext..[[
        <tr>
            <td align=right><strong>]]..data[1]..[[</strong></td>
            <td align=left>]]..data[2]..(data[3] and ' <span title="'..data[3]..'">(<u>?</u>)</span>' or '')..[[</td>
        </tr>
]]
                    end
                end
                bodytext = bodytext..[[
    </table>
    </p>
</details>

]]
            end
        end


        if bp.Veteran and bp.Veteran.Level1 then
            bodytext = bodytext..[[

### Veteran levels

]]
            if not bp.Weapon or (bp.Weapon and #bp.Weapon == 1 and IsDeathWeapon(bp.Weapon[1])) then
                bodytext = bodytext .. [[This unit has defined veteran levels, despite not having any weapons. Other effects can still give experience towards those levels though, which are as follows; note they replace each other by default:
]]
            else
                bodytext = bodytext .. [[Note: Each veteran level buff replaces the previous by default; values are shown here as written.
]]
            end

            for i = 1, 5 do
                local lev = 'Level'..i
                if bp.Veteran[lev] then
                    bodytext = bodytext .. [[

]]..i..'. '..bp.Veteran[lev]..' kills gives: '..iconText('Health', bp.Defense and bp.Defense.MaxHealth and '+'..(bp.Defense.MaxHealth / 10 * i) )
                    for buffname, buffD in pairs(bp.Buffs) do
                        if buffD[lev] then
                            if buffname == 'Regen' then
                                bodytext = bodytext..' (+'..buffD[lev]..'/s)'
                            else
                                bodytext = bodytext..' '..buffname..': '..buffD[lev]
                            end
                        end
                    end
                end
            end
            bodytext = bodytext..[[

]]
        end

        ------------------------------------------------------------------------
        -- Sidebar stuff
        ------------------------------------------------------------------------
        if not sidebarData[modsidebarindex] then
            sidebarData[modsidebarindex] = {modname, {}, modinfo}
        end

        local goodfactions = {
            UEF = 'UEF',
            Aeon = 'Aeon',
            Seraphim = 'Seraphim',
            Cybran = 'Cybran',
        }

        local faction = goodfactions[bp.General and bp.General.FactionName] or 'Other'

        if not sidebarData[modsidebarindex][2][faction] then
            sidebarData[modsidebarindex][2][faction] = {}
        end

        table.insert(sidebarData[modsidebarindex][2][faction], {bpid, LOC(bp.General.UnitName) or bpid, unitTdesc or bpid})

        local categoriesForFooter = {
            'UEF',
            'AEON',
            'CYBRAN',
            'SERAPHIM',

            'TECH1',
            'TECH2',
            'TECH3',
            'EXPERIMENTAL',

            'MOBILE',

            'AIR',
            'LAND',
            'NAVAL',

            'HOVER',

            'ECONOMIC',

            'BOMBER',
            'TORPEDOBOMBER',
            'MINE',
            'COMMAND',
            'SUBCOMMANDER',
            'ENGINEER',
            'FIELDENGINEER',
            'FACTORY',
            'ARTILLERY',

            'STRUCTURE',
        }

        bodytext = bodytext..[[

<table align=center><td>
Categories : ]]

        local cattext = ''

        for i, cat in ipairs(categoriesForFooter) do
            if arrayfind(bp.Categories, cat) then

                if not categoryData[cat] then
                    categoryData[cat] = {}
                end

                table.insert(categoryData[cat], {bpid, LOC(bp.General.UnitName) or bpid, unitTdesc or bpid})

                if cattext ~= '' then
                    cattext = cattext..' · '
                end

                cattext = cattext..'<a href="_categories.'..cat..'">'..cat..'</a>'
            end
        end
        cattext = cattext..[[

]]
        md:write(headerstring..infoboxstring..bodytext..cattext)
        md:close()
    end

    print("Complete")

end

--------------------------------------------------------------------------------
-- ACTUALLY DO THE THING

for i, dir in ipairs(ListOfModDirectories) do
    local suc, msg = pcall(MakeWiki, dir, i)
    if not suc then print(msg); break end
end

--------------------------------------------------------------------------------
-- Do the sidebar stuff

do
    local suc, msg = pcall(function()
        print("starting sidebar stuff")

        local sortData = function(sorttable, sort)
            for modindex, moddata in ipairs(sorttable) do
                --local modname = moddata[1]
                for faction, unitarray in pairs(moddata[2]) do
                    table.sort(unitarray, function(a,b)
                        --return a[3] < b[3]
                        local g

                        if sort == 'TechDescending-DescriptionAscending' then
                            g = { ['Experi'] = 1, ['Tech 3'] = 2, ['Tech 2'] = 3, ['Tech 1'] = 4 }
                            return (g[string.sub(a[3], 1, 6)] or 5)..a[3] < (g[string.sub(b[3], 1, 6)] or 5)..b[3]

                        elseif sort == 'TechAscending-IDAscending' then
                            g = { ['Tech 1'] = 1, ['Tech 2'] = 2, ['Tech 3'] = 3, ['Experi'] = 4 }
                            return (g[string.sub(a[3], 1, 6)] or 5)..a[1] < (g[string.sub(b[3], 1, 6)] or 5)..b[1]

                        end
                    end)
                end
            end
        end

        sortData(sidebarData, 'TechDescending-DescriptionAscending')

        local sidebarstring = ''

        for modindex, moddata in ipairs(sidebarData) do
            local modname = moddata[1]

            sidebarstring = sidebarstring .. [[
<details markdown="1">
<summary>[Show] <a href="]]..string.gsub(modname, ':', '')..[[">]]..modname..[[</a></summary>
<p>
<table>
<tr>
<td>

]]
            for faction, unitarray in pairs(moddata[2]) do

                sidebarstring = sidebarstring .. [[
<details markdown="1">
<summary>]]..faction..[[</summary>
<p>

]]
                for unitI, unitData in ipairs(unitarray) do

                    sidebarstring = sidebarstring .. [[
* <a title="]]..unitData[2]..[[" href="../wiki/]]..unitData[1]..[[">]]..unitData[3]..[[</a>
]]

                end
                sidebarstring = sidebarstring .. [[
</p>
</details>
]]
            end
            sidebarstring = sidebarstring .. [[

</td>
</tr>
</table>
</p>
</details>
]]
        end

        local md = io.open(WikiRepoDir..'/_Sidebar.md', "w")
        md:write(sidebarstring)
        md:close()

        print("Sidebar done")

        sortData(sidebarData, 'TechAscending-IDAscending')

        for modindex, moddata in ipairs(sidebarData) do
            local modname = moddata[1]
            local modinfo = moddata[3]
            local mulString = '***'..modname..'*** is a mod by '..(modinfo.author or 'an unknown author')..'. Its mod menu description is:'..[[

<blockquote>]]..(modinfo.description or 'No description.')..[[</blockquote>
Version ]]..modinfo.version..[[ contains the following units:
]]

            for faction, unitarray in pairs(moddata[2]) do
                local curtechi = 0
                local thash = {
                    ['Tech 1'] = {1, 'Tech 1'},
                    ['Tech 2'] = {2, 'Tech 2'},
                    ['Tech 3'] = {3, 'Tech 3'},
                    ['Experi'] = {4, 'Experimental'},
                    ['Other']  = {5, 'Other'},
                }

                mulString = mulString .. [[

## ]]..faction..[[

]]
                for unitI, unitData in ipairs(unitarray) do
                    local tech = thash[string.sub(unitData[3], 1, 6)] or thash['Other']
                    if tech[1] > curtechi then
                        curtechi = tech[1]
                        mulString = mulString ..[[

### ]]..tech[2]..[[

]]
                    end

                    mulString = mulString .. [[<a title="]]..unitData[2]..[[" href="../wiki/]]..unitData[1]..[["><img src="]]..unitIconRepo..unitData[1]..[[_icon.png" /></a>
]]
                end
            end

            md = io.open(WikiRepoDir..'/'..string.gsub(modname, ':', '')..'.md', "w")
            md:write(mulString)
            md:close()

        end

        print("Mod-pages done")

        for cat, data in pairs(categoryData) do
            table.sort(data, function(a,b)
                g = { ['Tech 1'] = 1, ['Tech 2'] = 2, ['Tech 3'] = 3, ['Experi'] = 4 }
                return (g[string.sub(a[3], 1, 6)] or 5)..a[1] < (g[string.sub(b[3], 1, 6)] or 5)..b[1]
            end)

            local catstring = 'Units with the <code>'..cat..[[</code> category.
<table>
]]
            for i, unitData in ipairs(data) do
                catstring = catstring .. [[
<tr><td><a href="]]..unitData[1]..[["><img src="]]..unitIconRepo..unitData[1]..[[_icon.png" width="21px" /></a><td><code>]]..unitData[1]..[[</code></td><td><a href="]]..unitData[1]..[[">]]
                if unitData[1] ~= unitData[2] then
                    catstring = catstring..unitData[2]
                    if unitData[1] ~= unitData[3] then
                        catstring = catstring..[[: ]]
                    end
                end
                if unitData[1] ~= unitData[3] then
                    catstring = catstring..unitData[3]
                end
                catstring = catstring..[[</a>
]]
            end

            md = io.open(WikiRepoDir..'/_categories.'..cat..'.md', "w")
            md:write(catstring)
            md:close()


        end

        print("Categories done")
    end)
    if not suc then print(msg) end
end


--[[TODO:
Built by (dynamic)
Upgrade info
Adjacency.
    Buff details
Hide 0 radius?
pathing footprint?
strategic icons
Loyalist death weapon. Too specific scripted?

top level mod pages
]]
