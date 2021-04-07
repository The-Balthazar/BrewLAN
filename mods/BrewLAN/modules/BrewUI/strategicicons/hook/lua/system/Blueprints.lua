--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)
    OldModBlueprints(all_blueprints)

    BrewLANTechIconOverhaul(all_blueprints, false) -- Bool adds change logging.
    --UpdateForBrewLANTechIcons(all_blueprints)
end

--------------------------------------------------------------------------------
-- Utils
--------------------------------------------------------------------------------
local function arrayfindSubstring(tab, str)
    for i, v in tab do
        local s = string.find(v, str)
        if s then
            return s
        end
    end
end

local function unitHasWallCat(bp)
    local t = {
        WALL = true,
        MEDIUMWALL = true,
        HEAVYWALL = true,
        SHIELDWALL = true,
    }
    if bp.Categories then
        for i, cat in bp.Categories do
            if t[cat] then
                return true
            end
        end
    end
end

local function isDeathWep(wep)
    return (wep.Label == 'DeathWeapon' or wep.Label == 'DeathImpact' or wep.WeaponCategory == 'Death')
end

local function isUnarmed(bp)
    if not bp.Weapon then
        return true
    else
        for i, wep in bp.Weapon do
            if not isDeathWep(wep) then
                return false
            end
        end
        return true
    end
end

--------------------------------------------------------------------------------
-- Damage per second calculation, biased towards high damage
--------------------------------------------------------------------------------
local function biasedDPS(weapon)
    --Base values
    local bias = 1.2
    local ProjectileCount = math.max(1, table.getn(weapon.RackBones[1].MuzzleBones or {'boop'} ) ) * (weapon.MuzzleSalvoSize or 1)
    if weapon.RackFireTogether then
        ProjectileCount = ProjectileCount * math.max(1, table.getn(weapon.RackBones or {'boop'} ) )
    end
    local DamageInterval = math.floor((math.max(0.1, 1 / (weapon.RateOfFire or 1)) * 10) + 0.5) / 10  + ProjectileCount * math.max(weapon.MuzzleSalvoDelay or 0, weapon.MuzzleChargeDelay or 0)
    local Damage = (--[[math.max]](--[[weapon.DamageToShields or 0, ]]weapon.Damage or 0) + (weapon.NukeInnerRingDamage or 0)) * ProjectileCount * (weapon.DoTPulses or 1)

    if weapon.RackBones and table.getn(weapon.RackBones) > 1 then
        DamageInterval = DamageInterval + (weapon.RackReloadTimeout or 0)
    end
    if weapon.EnergyRequired and weapon.EnergyDrainPerSecond then
        DamageInterval = math.max(DamageInterval, weapon.EnergyRequired / weapon.EnergyDrainPerSecond, 0.1)
    end

    if weapon.BeamLifetime and weapon.BeamLifetime == 0 then
        DamageInterval = 0.1 + (weapon.BeamCollisionDelay or 0)
        return math.pow(Damage * (1 / DamageInterval), bias)  --Apply Bias to full second of continuous beams
    elseif weapon.BeamLifetime and weapon.BeamLifetime > 0 then
        DamageInterval = DamageInterval + weapon.BeamLifetime
        Damage = Damage * (weapon.BeamLifetime / (0.1 + (weapon.BeamCollisionDelay or 0) )) --Calculate damage as across the whole beam for non-continuous beams
    end

    return math.pow(Damage, bias) * (1 / DamageInterval)
end

local function NeoDPS(weapon)

    local projectiles, interval, damage = 0,0,0



    if weapon.RackBones and table.getn(weapon.RackBones) > 1 then
        interval = interval + weapon.RackReloadTimeout
    end
    if weapon.EnergyRequired and weapon.EnergyDrainPerSecond then
        interval = math.max(interval, weapon.EnergyRequired / weapon.EnergyDrainPerSecond, 0.1)
    end
end

--------------------------------------------------------------------------------
-- Identifies what icon type a weapon's stats should contribute towards
-- Can't identify if it should coult as a sniper, since that requites global stats.
-- Returns [type string], [multiplier number or nil]
--------------------------------------------------------------------------------
local function getWeaponType(bp, weapon, projectiles)

    if weapon.TargetType == 'RULEWTT_Projectile' then
        --Get the anti-projectile stuff out of the way first
        -- We don't specifically care about anti-torpedo, so just group it in with anti-navy
        if (weapon.TargetRestrictOnlyAllow == 'TORPEDO' or string.find(weapon.TargetRestrictOnlyAllow, 'TORPEDO')) then
            return 'antinavy'
        end

        -- we only distinguish between SMD and TMD for the multiplier bonus
        if (weapon.TargetRestrictOnlyAllow == 'MISSILE' or string.find(weapon.TargetRestrictOnlyAllow, 'MISSILE')) then
            return 'antimissile', (string.find(weapon.TargetRestrictOnlyAllow, 'STRATEGIC') and 1000 or string.find(weapon.TargetRestrictOnlyAllow, 'TACTICAL') and 100)
        end

        -- fallback error
        return 'antiprojectile', WARN((bp.General.UnitName or 'unnamed unit')..' '..(weapon.Label or 'nil').." identifies that it can target projectiles, but we can't identify which.")

    elseif weapon.TargetType == 'RULEWTT_Prop' then
        return 'antiprop', WARN((bp.General.UnitName or 'unnamed unit')..' '..(weapon.Label or 'nil').." identifies that it can only target props")

    else --weapon.TargetType == 'RULEWTT_Unit' then --Default value, generally not defined.

        --If the weapons projectile can be stopped by a TMD or SMD
        if weapon.ProjectileId then
            weapon.ProjectileId = string.lower(weapon.ProjectileId)
            if projectiles[weapon.ProjectileId]
            and projectiles[weapon.ProjectileId].Categories
            and table.find(projectiles[weapon.ProjectileId].Categories, 'MISSILE')
            then
                if table.find(projectiles[weapon.ProjectileId].Categories, 'STRATEGIC') then
                    --If an SMD could stop it, it's a nuke, use range as a multiplier
                    return 'nuke', math.max(1, weapon.MaxRadius / 100)
                elseif table.find(projectiles[weapon.ProjectileId].Categories, 'TACTICAL') then
                    --If a TMD could stop it, it's a 'missile', use range as a multiplier
                    return 'missile', math.max(1, weapon.MaxRadius / 100)
                end
            end
        end

        local layerCaps = '' -- Will be replaced with somethling like `Air|Land|Water`
        if weapon.FireTargetLayerCapsTable then
            if bp.Physics.MotionType == 'RULEUMT_Air'
            and weapon.FireTargetLayerCapsTable.Air then
                layerCaps = weapon.FireTargetLayerCapsTable.Air

            elseif (bp.Physics.MotionType == 'RULEUMT_Biped'
            or bp.Physics.MotionType == 'RULEUMT_Land')
            and weapon.FireTargetLayerCapsTable.Land then
                layerCaps = weapon.FireTargetLayerCapsTable.Land

            elseif bp.Physics.MotionType == 'RULEUMT_Water'
            and weapon.FireTargetLayerCapsTable.Water then
                layerCaps = weapon.FireTargetLayerCapsTable.Water

            else
                for fromlayer, targetlayers in weapon.FireTargetLayerCapsTable do
                    -- This assumes that the longest target layer caps list is the one that has all the target
                    if string.len(targetlayers or '') > string.len(layerCaps) then
                        layerCaps = targetlayers
                    end
                end
            end
        end

        layerCapsTable = {
            AIR = string.find(layerCaps, 'Air'),
            LAND = string.find(layerCaps, 'Land'),
            --ORBIT = string.find(layerCaps, 'Orbit'),
            SEABED = string.find(layerCaps, 'Seabed'),
            SUB = string.find(layerCaps, 'Sub'),
            WATER = string.find(layerCaps, 'Water'),
        }

        if layerCaps == 'Air'
        or weapon.TargetRestrictOnlyAllow == 'AIR'
        or (weapon.TargetRestrictOnlyAllow and string.find(weapon.TargetRestrictOnlyAllow, 'AIR'))
        or layerCapsTable.AIR and not (weapon.TargetRestrictDisallow and string.find(weapon.TargetRestrictDisallow, 'AIR')) then--This will also find HIGHALTAIR
            return 'antiair'
        end

        if (layerCapsTable.SEABED or layerCapsTable.SUB or layerCapsTable.WATER) and not (layerCapsTable.AIR or layerCapsTable.LAND) then
            return 'antinavy'
        end

        local KYS = {
            Suicide = true,
            Kamikaze = true,
        }

        if layerCapsTable.LAND or weapon.AboveWaterTargetsOnly or (weapon.ProjectileId and projectiles[weapon.ProjectileId].Physics.DestroyOnWater) then
            if weapon.ArtilleryShieldBlocks then
                return 'artillery', math.max(1, weapon.MaxRadius / 100)
            end

            local ShieldDamMult = string.sub(weapon.DamageType, 1, 10) == 'ShieldMult' and tonumber(string.sub(weapon.DamageType, 11, -1)) or (weapon.DamageToShields or weapon.ShieldDamage) and (weapon.DamageToShields or weapon.ShieldDamage) / weapon.Damage
            if (ShieldDamMult >= 2) then
                return 'antishield', ShieldDamMult

            elseif (weapon.FireOnSelfDestruct or KYS[weapon.WeaponCategory] or KYS[weapon.Label] or KYS[weapon.DisplayName]) and not weapon.NeedToComputeBombDrop then
                return 'bomb'

            else
                return 'directfire'
            end
        end
    end

    return 'unknown', WARN((bp.General.UnitName or 'unnamed unit')..' '..(weapon.Label or 'nil').." weapon can't be identified.")
end

--------------------------------------------------------------------------------
-- Shared icon get functions
--------------------------------------------------------------------------------
local function getDesiredBackground(bp, all_bps)

    --Megalith egg data pass through.
    if bp.Economy.BuildUnit and all_bps.Unit[bp.Economy.BuildUnit] then
        bp = all_bps.Unit[bp.Economy.BuildUnit]
    end

    if bp.ResearchId and all_bps.Unit[bp.ResearchId] then
        bp = all_bps.Unit[bp.ResearchId]
    end

    local level = (table.find(bp.Categories, 'EXPERIMENTAL') and 4)
    or (table.find(bp.Categories, 'TECH4') and 4)
    or (table.find(bp.Categories, 'TECH3') and 3)
    or (table.find(bp.Categories, 'TECH2') and 2)
    or (table.find(bp.Categories, 'TECH1') and 1)
    or ''

    local icon

    if table.find(bp.Categories, 'COMMAND') then
        return 'commander' -- Commander type has no level variants
    elseif table.find(bp.Categories, 'SUBCOMMANDER') then
        return 'subcommander' -- Commander type has no level variants
    elseif unitHasWallCat(bp) then
        icon = 'structure'
    elseif bp.Physics.MotionType == 'RULEUMT_Air' then

        if bp.Physics.Evelation > 50 or table.find(bp.Categories, 'SATELLITE') then
            icon = 'satellite'

        elseif bp.Air and bp.Air.Winged then
            if level == 4 or table.find(bp.Categories, 'BOMBER') and table.find(bp.Categories, 'ANTIAIR') then
                icon = 'air'
            elseif table.find(bp.Categories, 'BOMBER') or table.find(bp.Categories, 'TORPEDOBOMBER') then
                icon = 'bomber'
            else
                icon = 'fighter'
            end
        else
            icon = 'gunship'
        end

    elseif bp.Physics.MotionType == 'RULEUMT_Biped'
    or bp.Physics.MotionType == 'RULEUMT_Land' then
        icon = 'land'

    elseif bp.Physics.MotionType == 'RULEUMT_Hover'
    or bp.Physics.MotionType == 'RULEUMT_AmphibiousFloating' then
        icon = 'surface'

    elseif bp.Physics.MotionType == 'RULEUMT_Amphibious' then
        icon = 'seabed'

    elseif bp.Physics.MotionType == 'RULEUMT_Water' then
        icon = 'ship'

    elseif bp.Physics.MotionType == 'RULEUMT_SurfacingSub' then
        icon = 'sub'

    else--if bp.Physics.MotionType == 'RULEUMT_None' then
        if table.find(bp.Categories, 'FACTORY') then
            icon = 'factory'
        elseif (bp.Adjacency or bp.BuffFields or table.find(bp.Categories, 'NODE') or (bp.General and bp.General.Classification == 'RULEUC_MiscSupport' )) and
        not (bp.Economy.ProductionPerSecondEnergy and bp.Economy.ProductionPerSecondEnergy > 0 or bp.Economy.MaxEnergy and bp.Economy.MaxEnergy > 0) and
        not (bp.Economy.ProductionPerSecondMass and bp.Economy.ProductionPerSecondMass > 0 or bp.Economy.MaxMass and bp.Economy.MaxMass > 0)
        and isUnarmed(bp)
        and level ~= '' then
            icon = 'node'
        else
            icon = 'structure'
        end
    end
    return icon .. level
end

local function getDesiredIcon(bp, all_bps)

    --Megalith egg data pass through.
    if bp.Economy.BuildUnit and all_bps.Unit[bp.Economy.BuildUnit] then
        bp = all_bps.Unit[bp.Economy.BuildUnit]
    end

    if bp.ResearchId and all_bps.Unit[bp.ResearchId] then
        bp = all_bps.Unit[bp.ResearchId]
    end

    --Predefined
    if bp.StrategicIcon then return bp.StrategicIcon end

    local icon = ''
    if unitHasWallCat(bp) then
        if table.find(bp.Categories, 'SHIELDWALL') then
            icon = 'shieldwall'
        else
            icon = 'wall' -- Wall is is only a possible subtype
        end
    elseif table.find(bp.Categories, 'COMMAND') or table.find(bp.Categories, 'SUBCOMMANDER') then
        icon = 'generic'
    elseif table.find(bp.Categories, 'ECONOMIC') and (
        table.find(bp.Categories, 'MASSPRODUCTION')
        or table.find(bp.Categories, 'MASSFABRICATION')
        or table.find(bp.Categories, 'MASSSTORAGE')
        or table.find(bp.Categories, 'ENERGYPRODUCTION')
        or table.find(bp.Categories, 'ENERGYSTORAGE')
    )
    then
        if table.find(bp.Categories, 'MASSPRODUCTION') or table.find(bp.Categories, 'MASSFABRICATION') then
            icon = 'mass'
            --Check Economy.ProductionPerSecondEnergy?
        elseif table.find(bp.Categories, 'ENERGYPRODUCTION') or table.find(bp.Categories, 'ENERGYSTORAGE') and (not table.find(bp.Categories, 'MASSSTORAGE') or bp.Weapon[1]) then -- If it has both, only give it E if it explodes.
            icon = 'energy'
        elseif table.find(bp.Categories, 'MASSSTORAGE') then
            icon = 'mass'
        end
    elseif table.find(bp.Categories, 'FIELDENGINEER') or table.find(bp.Categories, 'ENGINEER') or table.find(bp.Categories, 'ENGINEERSTATION')--[[or table.find(bp.Categories, 'CONSTRUCTION')-- removed because it counts too much]]  then
        icon = 'engineer'
    elseif table.find(bp.Categories, 'TRANSPORTATION') and bp.Transport and bp.Transport.TransportClass > 3 then
        icon = 'transport'
    elseif table.find(bp.Categories, 'CARRIER') and bp.Transport and not (bp.Economy.BuildableCategory and arrayfindSubstring(bp.Economy.BuildableCategory, 'LAND')) then
        icon = 'air'
    elseif table.find(bp.Categories, 'ANTIARTILLERY') or bp.Defense and bp.Defense.Shield and bp.Defense.Shield.AntiArtilleryShield and not (bp.Defense.Shield.PersonalShield == true) then
        icon = 'antiartillery'
    --elseif table.find(bp.Categories, 'ANTISHIELD') then
    --    icon = 'antishield'
    elseif --[[table.find(bp.Categories, 'COUNTERINTELLIGENCE') and]] bp.Intel and (bp.Intel.CloakFieldRadius or bp.Intel.RadarStealthFieldRadius or bp.Intel.SonarStealthFieldRadius) then --Prioritise counterintel over weapon if it has a field generator
        icon = 'counterintel'
    elseif table.find(bp.Categories, 'RESEARCHCENTRE') then
        icon = 'research'
    elseif bp.Defense and bp.Defense.Shield and not (bp.Defense.Shield.PersonalShield == true) and bp.Defense.Shield.ImpactMesh and string.lower(bp.Defense.Shield.ImpactMesh) == '/effects/entities/shieldsection01/shieldsection01_mesh' and math.max(bp.Defense.Shield.ShieldSize, bp.Defense.Shield.ShieldProjectionRadius or 0) > math.max(bp.SizeX or 1, bp.SizeZ or 1) * 5 then
        icon = 'shield'
    elseif not isUnarmed(bp) then

        --[[if not (
            table.find(bp.Categories, 'DIRECTFIRE')
            or table.find(bp.Categories, 'GROUNDATTACK')
            or table.find(bp.Categories, 'ANTIAIR')
            or table.find(bp.Categories, 'ANTINAVY')
            or table.find(bp.Categories, 'ANTISUB')
            or table.find(bp.Categories, 'BOMBER')
            or table.find(bp.Categories, 'ARTILLERY')
            or table.find(bp.Categories, 'INDIRECTFIRE')
            or table.find(bp.Categories, 'MISSILE')
            or table.find(bp.Categories, 'NUKE')
            or table.find(bp.Categories, 'SILO')
            or table.find(bp.Categories, 'MINE')
        ) then
            WARN( (bp.General.UnitName or bp.Description or 'nil') .. " has a weapon but no weapon category" )
        end]]

        --FIGHT FOR YOUR ICON! LITERALLY!
        local layer = { -- Pre-populated list, so that we don't get the error types.
            antiair = 0,
            artillery = 0,
            directfire = 0,
            sniper = 0,
            antinavy = 0,
            nuke = 0,
            missile = 0,
            bomb = 0,
            antimissile = 0,
            antishield = 0,
            intel = bp.Intel and math.max(
                (bp.Intel.SonarRadius or 0) * 1,
                (bp.Intel.RadarRadius or 0) * 1,
                (bp.Intel.OmniRadius or 0) * 2
            ) or 0,
        }
        for i, weapon in bp.Weapon do
            if not isDeathWep(weapon) then
                local weaponlayer, mult = getWeaponType(bp, weapon, all_bps.Projectile)
                bp.Weapon[i].BLType = weaponlayer
                if layer[weaponlayer] then
                    layer[weaponlayer] = layer[weaponlayer] + (biasedDPS(weapon) * (mult or 1))
                end
            end
        end
        --WARN(bp.General.UnitName or 'nil')
        for i, v in layer do --This is so it logs less meaningless data.
            if v == 0 then layer[i] = nil end
        end
        --WARN(repr(layer))
        --if bp.Description == '<LOC sa0314_desc>Penetrator Bomber' then
        --    WARN(repr(layer))
        --end

        local best = {0, 'directfire'}
        for l, data in layer do
            if data > best[1] then
                best[1] = data
                best[2] = l
            end
        end
        icon = best[2]
    elseif table.find(bp.Categories, 'ANTIMISSILE') then
        icon = 'antimissile'
    elseif table.find(bp.Categories, 'COUNTERINTELLIGENCE') then
        icon = 'counterintel'
    elseif table.find(bp.Categories, 'AIRSTAGINGPLATFORM') then
        icon = 'air'
    elseif table.find(bp.Categories, 'SHIELD') then
        icon = 'shield'
    elseif table.find(bp.Categories, 'TRANSPORTATION') or table.find(bp.Categories, 'STARGATE') then
        icon = 'transport'
    elseif table.find(bp.Categories, 'INTELLIGENCE') then
        icon = 'intel'
    elseif table.find(bp.Categories, 'FACTORY') then
        local buildlayers = {
            'LAND',
            'AIR',
            'NAVAL',
        }
        local bits = {'0','0','0'}
        if bp.Economy.BuildableCategory and type(bp.Economy.BuildableCategory[1]) == "string" then
            for i, layer in buildlayers do
                for _, buildcat in bp.Economy.BuildableCategory do
                    --Count it if it's a generic category that matches
                    if string.find(buildcat, layer)
                    -- as long as it's not a construction specific category
                    and not string.find(buildcat, 'CONSTRUCTION')
                    --else if it's a unit
                    or all_bps.Unit[buildcat]
                    and all_bps.Unit[buildcat].Categories
                    --check the categories of that unit for the match instead
                    and table.find(all_bps.Unit[buildcat].Categories, layer)
                    -- as long as it's not an engineer type
                    and not table.find(all_bps.Unit[buildcat].Categories, 'CONSTRUCTION')
                    -- anod not something this upgrades into.
                    and not (bp.General and bp.General.UpgradesTo == buildcat) then
                        bits[i] = '1'
                        break
                    end
                end
            end
        end
        local sbits = table.concat(bits)
        if sbits == '000' then
            --If we got nothing from the build cats at all, check unit cats
            --It's easier than trying to parse custom categories, which wouldn't work for the Gantries anyway.
            for i, layer in buildlayers do
                bits[i] = table.find(bp.Categories, layer) and '1' or '0'
            end
            sbits = table.concat(bits)
        end
        if sbits == '100' then
            icon = 'land'
        elseif sbits == '010' then
            icon = 'air'
        elseif sbits == '001' then
            icon = 'naval'
        else
            icon = 'generic' -- Hopefully if we get here we're just the UEF Gantry
        end
    elseif bp.Adjacency or bp.BuffFields or table.find(bp.Categories, 'NODE') then
        icon = 'cross'
    else
        icon = 'generic'
    end
    return icon
end

--------------------------------------------------------------------------------
-- Modifies the strategic icon shape, but not the icon overlay.
--------------------------------------------------------------------------------
function UpdateForBrewLANTechIcons(all_bps)
    for id, bp in all_bps.Unit do
        if bp.StrategicIconName and bp.Categories and bp.Physics and bp.Physics.MotionType and bp.Economy then

            local iconShapeStart = 5 -- eg: '_land~~', to skip passed the fixed 'icon'
            local iconTypeStart = string.find(bp.StrategicIconName, '_', iconShapeStart+2) -- eg: '_directfire~~'
            local iconType = string.sub(bp.StrategicIconName, iconTypeStart)
            if iconType == '_generic' and string.sub(bp.StrategicIconName, 6, 8) ~= 'com' then
                iconType = '_'..getDesiredIcon(bp, all_bps)
            end
            bp.StrategicIconName = 'icon_'..getDesiredBackground(bp, all_bps)..iconType
        end
    end
end

--------------------------------------------------------------------------------
-- Full strength sanity check.
--------------------------------------------------------------------------------
function BrewLANTechIconOverhaul(all_bps, doLogChanges)
    ----------------------------------------------------------------------------
    local changes
    if doLogChanges then
        changes = {}
    end
    ----------------------------------------------------------------------------
    local group = {
           air = 'air',
        bomber = 'air',
       fighter = 'air',
       gunship = 'air',
     satellite = 'satellite',
       factory = 'structure',
     structure = 'structure',
          node = 'structure',
          ship = 'naval',
           sub = 'naval',
           bot = 'land',
          land = 'land',
        seabed = 'land',
       surface = 'land',
    }

    icons = {
        air = true,
        antiair = true,
        antiartillery = true,
        antimissile = true,
        antinavy = true,
        antishield = true,
        artillery = true,
        bomb = true,
        counterintel = true,
        cross = true,
        directfire = true,
        energy = true,
        engineer = true,
        generic = true,
        intel = true,
        land = true,
        mass = true,
        missile = true,
        naval = true,
        nuke = true,
        research = true,
        shield = true,
        sniper = true,
        transport = true,
    }

    local sniperrev = {}
    local revisit = {}

    local sniperdata = {}
    local data = {}

    for id, bp in all_bps.Unit do
        if bp.StrategicIconName and bp.Categories and bp.Physics and bp.Physics.MotionType and bp.Economy then
            local bgN = getDesiredBackground(bp, all_bps)
            local icon = getDesiredIcon(bp, all_bps)

            --------------------------------------------------------------------
            if doLogChanges then
                changes[id] = {bp.StrategicIconName, 'icon_'..bgN..'_'..icon}
            end
            --------------------------------------------------------------------
            bp.StrategicIconName = 'icon_'..bgN..'_'..icon

            if (icon == 'directfire' or icon == 'artillery' or icon == 'antiair') and not isUnarmed(bp) and string.sub(bgN, 1, -2) ~= 'node' then
                local n = {true,true,true,true}

                local level = tonumber(string.sub(bgN, -1, -1))

                if n[level] then

                    table.insert(revisit, id)
                    local bg = string.sub(bgN, 1, -2)

                    bp.StrategicBG = bg
                    bp.StrategicLevel = level
                    bp.StrategicIcon = icon

                    if not data[ group[bg]..level..icon ] then
                        data[ group[bg]..level..icon ] = { val = 0, total = 0 }
                    end

                    data[ group[bg]..level..icon ].val = data[ group[bg]..level..icon ].val + bp.Economy.BuildCostEnergy
                    data[ group[bg]..level..icon ].total = data[ group[bg]..level..icon ].total + 1

                    if (icon == 'directfire') then
                        local range = 0
                        for i, wep in bp.Weapon do
                            if wep.BLType == 'directfire' and wep.MaxRadius > range and not wep.NeedToComputeBombDrop then
                                range = wep.MaxRadius
                            end
                        end
                        if range > 0 then

                            table.insert(sniperrev, id)
                            if not sniperdata[ group[bg]..level..icon ] then
                                sniperdata[ group[bg]..level..icon ] = { val = 0, total = 0 }
                            end

                            bp.StrategicTestRange = range
                            sniperdata[ group[bg]..level..icon ].val = sniperdata[ group[bg]..level..icon ].val + range
                            sniperdata[ group[bg]..level..icon ].total = sniperdata[ group[bg]..level..icon ].total + 1

                        end
                    end
                end
            end
        end
    end

    --WARN(repr(sniperdata))
    local sniperavgs = {}
    for k, v in sniperdata do
        sniperavgs[k] = v.val / v.total
    end
    --WARN(repr(sniperavgs))

    --WARN("Sniper Range table")
    --WARN("Group, unit, range average mult")
    for i, id in sniperrev do
        local bp = all_bps.Unit[id]
        --WARN(group[bp.StrategicBG]..bp.StrategicLevel..", "..(bp.General.UnitName or 'nil') .. ", " .. bp.StrategicTestRange / sniperavgs[ group[bp.StrategicBG]..bp.StrategicLevel..bp.StrategicIcon ])
        if bp.StrategicTestRange > sniperavgs[ group[bp.StrategicBG]..bp.StrategicLevel..bp.StrategicIcon ] * 1.3 then
            --------------------------------------------------------------------
            if doLogChanges then
                changes[id][2] = 'icon_'..bp.StrategicBG..bp.StrategicLevel..'_sniper'
            end
            --------------------------------------------------------------------
            -- Do the thing
            bp.StrategicIconName = 'icon_'..bp.StrategicBG..bp.StrategicLevel..'_sniper'
            --WARN(bp.StrategicIconName .. " : " ..(bp.General.UnitName or 'nil') .. " is cool enough to get the sniper icon ")

            -- Remove from directfire averages data
            data[ group[bp.StrategicBG]..bp.StrategicLevel..bp.StrategicIcon ].total = data[ group[bp.StrategicBG]..bp.StrategicLevel..bp.StrategicIcon ].total - 1
            data[ group[bp.StrategicBG]..bp.StrategicLevel..bp.StrategicIcon ].val = data[ group[bp.StrategicBG]..bp.StrategicLevel..bp.StrategicIcon ].val - bp.Economy.BuildCostEnergy

            -- Cleanup
            bp.StrategicTestRange = nil
            bp.StrategicIcon = nil
            bp.StrategicBG = nil
            bp.StrategicLevel = nil
        end
    end

    --WARN(repr(data))
    local avgs = {}
    for k, v in data do
        avgs[k] = v.val / v.total
    end
    --WARN(repr(avgs))

    for i, id in revisit do
        local bp = all_bps.Unit[id]
        if bp.StrategicIcon--[[skip things that are now sniper]] and bp.Economy.BuildCostEnergy >= avgs[ group[bp.StrategicBG]..bp.StrategicLevel..bp.StrategicIcon ] then
            --------------------------------------------------------------------
            if doLogChanges then
                changes[id][2] = bp.StrategicIconName .. '2'
            end
            --------------------------------------------------------------------
            -- Do the thing
            bp.StrategicIconName = bp.StrategicIconName .. '2'
            --WARN(bp.StrategicIconName .. " : " ..(bp.General.UnitName or 'nil') .. " is cool enough to get the better icon ")

            -- Cleanup
            bp.StrategicTestRange = nil
            bp.StrategicBG = nil
            bp.StrategicLevel = nil
            bp.StrategicIcon = nil
        end
    end

    if doLogChanges then
        LOG('BrewLAN strategic icon changes. Units processed: '..table.getsize(changes))
        LOG('ID, Original strategic icon, Calculated name')
        for id, icons in changes do
            if icons[1] ~= icons[2] then
                LOG(id..', '..icons[1]..', '..icons[2])
            end
        end
        --LOG(repr(changes))
    end
end

end
