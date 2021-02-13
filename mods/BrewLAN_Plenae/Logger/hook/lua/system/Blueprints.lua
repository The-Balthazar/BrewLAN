--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)
    OldModBlueprints(all_blueprints)

    CheckUnitHasCorrectIcon(all_blueprints.Unit)

    --ListAllUnitsNamesDescriptionsForRNN(all_blueprints.Unit)
    --CheckLOCTags(all_blueprints.Unit)
    --CheckAllUnitBackgroundImages(all_blueprints.Unit)
    --CheckAllUnitThreatValues(all_blueprints.Unit)
    --CheckCollisionSphereLargeEnoughForMaxSpeed(all_blueprints.Unit)
    --CheckEvenFlowOutliers(all_blueprints.Unit)

    --FindUnusedFiles(all_blueprints.Unit)
    --CheckWeaponDamage(all_blueprints.Unit)

    --IvanCheckUnitWeight(all_blueprints.Unit)
end

function ShouldWeLogThis(id, bp)
    --return units and table.find(units, id)
    return string.sub(bp.Source, 1, 13) == '/mods/brewlan'
    --return table.find(bp.Categories, 'SELECTABLE') and (table.find(bp.Categories, 'TECH1') or table.find(bp.Categories, 'TECH2') or table.find(bp.Categories, 'TECH3') or table.find(bp.Categories, 'EXPERIMENTAL') )
end

function CheckUnitHasCorrectIcon(all_bps)
    WARN("DO THE ICON CHECK")
    for id, bp in all_bps do
        if ShouldWeLogThis(id, bp) and bp.Categories then

            local level = (table.find(bp.Categories, 'EXPERIMENTAL') and 4 or 0)
            + (table.find(bp.Categories, 'TECH4') and 4 or 0)
            + (table.find(bp.Categories, 'TECH3') and 3 or 0)
            + (table.find(bp.Categories, 'TECH2') and 2 or 0)
            + (table.find(bp.Categories, 'TECH1') and 1 or 0)

            local icon = 'icon_'
            --[[local part2 = {
                'experimental',

                'bomber',
                'fighter',
                'gunship',
                'factory',
                'structure',
                'ship',
                'sub',
                'bot',
                'land',

                'objective',
                'strategic',

                'commander',
                'wall',
            }]]

            if level < 4 and bp.Physics then

                if table.find(bp.Categories, 'SUBCOMMANDER') or table.find(bp.Categories, 'COMMAND') then
                    icon = icon..'commander'
                else
                    if bp.Physics.MotionType == 'RULEUMT_Air' then
                        if bp.Air and bp.Air.Winged then
                            if table.find(bp.Categories, 'BOMBER') or table.find(bp.Categories, 'TORPEDOBOMBER') then
                                icon = icon..'bomber' else
                                icon = icon..'fighter' end else
                            icon = icon..'gunship'
                        end

                    elseif bp.Physics.MotionType == 'RULEUMT_None' then
                        if table.find(bp.Categories, 'FACTORY') then
                            icon = icon..'factory' else
                            icon = icon..'structure'
                        end

                    elseif bp.Physics.MotionType == 'RULEUMT_SurfacingSub' then
                        icon = icon..'sub'

                    elseif bp.Physics.MotionType == 'RULEUMT_Water'
                    or bp.Physics.MotionType == 'RULEUMT_AmphibiousFloating'
                    and bp.Physics.AltMotionType == 'RULEUMT_Water' then
                        icon = icon..'ship'

                    elseif bp.Physics.MotionType == 'RULEUMT_Biped'
                    or bp.Physics.MotionType == 'RULEUMT_Land'
                    or bp.Physics.MotionType == 'RULEUMT_Amphibious'
                    or bp.Physics.MotionType == 'RULEUMT_Hover'
                    or bp.Physics.MotionType == 'RULEUMT_AmphibiousFloating'
                    then
                        if bp.Display and bp.Display.AnimationWalk then
                            icon = icon..'bot' else
                            icon = icon..'land'
                        end
                    end

                    if level ~= 0 then
                        icon = icon..level
                    end

                end
                icon = icon..'_'


                if level ~= 0 and (not (bp.StrategicIconName and string.sub(bp.StrategicIconName, 1, string.len(icon) ) == icon) or not bp.StrategicIconName) then
                    LOG((bp.General and LOC(bp.General.UnitName or 'Unnamed')).." unit with id: "..id
                    .." should have an icon starting "..icon.." but has "..(bp.StrategicIconName or 'nil'))
                end
            end


            --[[local level = (table.find(bp.Categories, 'EXPERIMENTAL') and 4 or 0)
            + (table.find(bp.Categories, 'TECH4') and 4 or 0)
            + (table.find(bp.Categories, 'TECH3') and 3 or 0)
            + (table.find(bp.Categories, 'TECH2') and 2 or 0)
            + (table.find(bp.Categories, 'TECH1') and 1 or 0)
            --LOG(level)
            local message = (bp.General and LOC(bp.General.UnitName or 'Unnamed')).." unit with id: "..id
            if level > 4 then
                LOG(message.." has more than one tech level category.")
            elseif level == 4 then
                if (bp.StrategicIconName and not string.sub(bp.StrategicIconName, 1, 17) == 'icon_experimental') then
                    LOG(message.." should have 'icon_experimental_generic' but has "..(bp.StrategicIconName or 'nil'))
                --elseif bp.StrategicIconName == 'icon_experimental_generic' then
                --    LOG("We gud")
                end
            elseif level ~= 0 then
                if (bp.StrategicIconName and not string.find(bp.StrategicIconName, tostring(level))) or not bp.StrategicIconName then
                    LOG(message.." should have an icon with "..tostring(level).." but has "..(bp.StrategicIconName or 'nil'))
                end
            end]]
        end
    end
    WARN("DOne")
end

function IvanCheckUnitWeight(all_bps)
    for id, bp in all_bps do
        if ShouldWeLogThis(id, bp) and bp.General.UnitName and table.find(bp.Categories, 'UEF') and table.find(bp.Categories, 'LAND') and table.find(bp.Categories, 'SELECTABLE') and table.find(bp.Categories, 'MOBILE') then
            LOG((bp.General.UnitName or "nil") ..","..((bp.Defense.MaxHealth or 1) .. ",".. (bp.SizeX or 1) * (bp.SizeY or 1) * (bp.SizeZ or 1)))
        end
    end
end


function CheckWeaponDamage(all_bps)
    local unitsdata = {}
    for id, bp in all_bps do
        if ShouldWeLogThis(id, bp) and bp.Weapon then
            for wi, weap in bp.Weapon do
                if weap.Damage < 10 then
                    table.insert(unitsdata, {id, weap.Damage, weap.Label, (weap.TargetType or 'nil')})
                end
            end
        end
    end
    LOG(repr(unitsdata))
end

--------------------------------------------------------------------------------
-- Logs
--------------------------------------------------------------------------------
function CheckLOCTags(all_bps)
    for id, bp in all_bps do
        if ShouldWeLogThis(id, bp) then
            --[[
            bp.Description
            bp.General.UnitName
            ]]
            local loctable = import('/mods/brewlan/hook/loc/us/strings_db.lua')
            local name = LOC(bp.General.UnitName)
            local nameref = LOCref(bp.General.UnitName)
            local desc = LOC(bp.Description)
            local descref = LOCref(bp.Description)
            LOG(id, name, nameref, loctable[nameref], desc, descref, loctable[descref])
        end
    end
end

function EvenFlow(all_bps)
    local brm = 2
    for id, bp in all_bps do
        if ShouldWeLogThis(id, bp) and bp.Categories and bp.Economy and bp.Economy.BuildCostEnergy and bp.Economy.BuildCostMass and bp.Economy.BuildTime then
            local DataTable = {
                STRUCTURE = {1, 0.1},
                EXPERIMENTAL = {1, 0.1},
                TECH1 = {2.5 * brm, brm * 0.125},
                TECH2 = {2.5 * brm, brm * 0.08928571428571428571428571428572},
                TECH3 = {2.5 * brm, brm * 0.06578947368421052631578947368421},
            }
            local newtime
            for i, cat in bp.Categories do
                for Ccat, data in DataTable do
                    if cat == Ccat then
                        newtime = math.ceil(math.max( 1, bp.Economy.BuildCostMass * data[1], bp.Economy.BuildCostEnergy * data[2]))
                        bp.Economy.BuildTime = newtime
                        if cat == 'STRUCTURE' and brm ~= 1 and bp.Economy.BuildRate and table.find(bp.Categories, 'FACTORY') then
                            bp.Economy.BuildRate = bp.Economy.BuildRate * brm
                            for j, catj in bp.Categories do
                                if catj == 'TECH2' or catj == 'TECH3' then
                                    bp.Economy.BuildTime = bp.Economy.BuildTime * brm
                                end
                            end
                        end
                        break
                    end
                end
                if newtime then
                    break
                end
            end
        end
    end
end

function CheckEvenFlowOutliers(all_bps)
    local Delta = {}
    local brm = 1
    for id, bp in all_bps do
        if ShouldWeLogThis(id, bp) and bp.Categories and bp.Economy and bp.Economy.BuildCostEnergy and bp.Economy.BuildCostMass and bp.Economy.BuildTime then
            local DataTable = {
                STRUCTURE = {1, 0.1},
                EXPERIMENTAL = {1, 0.1},
                TECH1 = {2.5 * brm, brm * 0.125},
                TECH2 = {2.5 * brm, brm * 0.08928571428571428571428571428572},
                TECH3 = {2.5 * brm, brm * 0.06578947368421052631578947368421},
            }
            local newtime
            for i, cat in bp.Categories do
                for Ccat, data in DataTable do
                    if cat == Ccat then
                        newtime = math.ceil(math.max( 1, bp.Economy.BuildCostMass * data[1], bp.Economy.BuildCostEnergy * data[2]))
                        table.insert(Delta, {id, math.abs(bp.Economy.BuildTime / newtime), bp.Economy.BuildTime, newtime} )
                        break
                    end
                end
                if newtime then
                    break
                end
            end
        end
    end
    table.sort(Delta, function(a, b) return a[2] > b[2] end)
    LOG(repr(Delta))
end

function ListAllUnitsNamesDescriptionsForRNN(all_bps)
    WARN("RNN LIST THING HERE   ------   SDFGKLHJBSDFLJKHSBDF")
    for id, bp in all_bps do
        if ShouldWeLogThis(id, bp) and bp.Weapon and bp.Categories and table.find(bp.Categories, 'SERAPHIM') then
            local artillery = false
            for i, weapon in bp.Weapon do
                if weapon.ArtilleryShieldBlocks then
                    artillery = true
                    LOG(weapon.DisplayName)
                end
            end
            if artillery then
                LOG(bp.General.UnitName)
            end
        end
    end
    WARN("RNN LIST THING HERE   ------   SDFGKLHJBSDFLJKHSBDF")
    for tech, ptech in {['TECH1'] = 'Tech 1 ',['TECH2'] = 'Tech 2 ',['TECH3'] = 'Tech 3 ',['EXPERIMENTAL'] = ''} do
        for id, bp in all_bps do
            if ShouldWeLogThis(id, bp) and bp.Categories and table.find(bp.Categories, tech) and table.find(bp.Categories, 'SERAPHIM') then
                if bp.General.UnitName and bp.Description then
                    LOG(LOC(bp.General.UnitName) .. ': ' .. ptech .. LOC(bp.Description))
                end
            end
        end
    end
end

function CheckAllUnitBackgroundImages(all_bps)
    for id, bp in all_bps do
        if ShouldWeLogThis(id, bp) then
            CheckUnitHasCorrectIconBackground(id, bp)
        end
    end
end

function CheckCollisionSphereLargeEnoughForMaxSpeed(all_bps)
    for id, bp in all_bps do
    	if ShouldWeLogThis(id, bp) and bp.SizeSphere and bp.Air.MaxAirspeed then
            local correctMin = bp.Air.MaxAirspeed * 0.095
            if bp.SizeSphere < correctMin then
        		LOG(id ..  " has a size sphere of " .. bp.SizeSphere .. ", but needs at least " .. correctMin)
            elseif bp.SizeSphere > correctMin + 0.1 then
                LOG(id ..  " has a size sphere of " .. bp.SizeSphere .. ", but could have as low as " .. correctMin)
            end
    		--bp.SizeSphere = math.max( 0.9, bp.Air.MaxAirspeed * 0.095 )
    		--LOG("*AI DEBUG "..bp.Description.." has a new sphere of "..bp.SizeSphere)
    	end
    end
end

function FindUnusedFiles(all_bps)
    local models = DiskFindFiles('/units/', '*lod0.scm')
    local bps = DiskFindFiles('/units/', '*.bp')
    local modelsnobp = {}
    for i, path in models do
        if not table.find(bps, string.gsub(path, 'lod0.scm', 'unit.bp' )) then
            table.insert(modelsnobp, path)
        end
    end
    WARN("Potentially long list of unused lod0 models:")
    LOG(repr(modelsnobp))
end

function CheckAllUnitThreatValues(all_bps)
    local LOGOutput = {}
    for id, bp in all_bps do
    --for i, id in units do local bp = all_bps[id]
        if ShouldWeLogThis(id, bp) then
        --if table.find(bp.Categories, 'INDIRECTFIRE') and table.find(bp.Categories, 'UEF') then
            --Define output table
            LOGOutput[id] = {
                Description = LOC(bp.Description),
                Defense = {
                    AirThreatLevel = 0,
                    EconomyThreatLevel = 0,
                    SubThreatLevel = 0,
                    SurfaceThreatLevel = 0,
                    --These are temporary to be merged into the others after calculations
                    HealthThreat = 0,
                    PersonalShieldThreat = 0,
                    UnknownWeaponThreat = 0,
                }
            }
            LOG(id)--For checking what breaks it
            --define base health and shield values
            if bp.Defense.MaxHealth then
                LOGOutput[id].Defense.HealthThreat = bp.Defense.MaxHealth * 0.01
            end
            if bp.Defense.Shield then
                local shield = bp.Defense.Shield                                               --ShieldProjectionRadius entirely only for the Pillar of Prominence
                local shieldarea = (shield.ShieldProjectionRadius or shield.ShieldSize or 0) * (shield.ShieldProjectionRadius or shield.ShieldSize or 0) * math.pi
                local skirtarea = (bp.Physics.SkirtSizeX or 3) * (bp.Physics.SkirtSizeY or 3)                                                              -- Added so that transport shields dont count as personal shields.
                if (bp.Display.Abilities and table.find(bp.Display.Abilities,'<LOC ability_personalshield>Personal Shield') or shieldarea < skirtarea) and not table.find(bp.Categories, 'TRANSPORT') then
                    LOGOutput[id].Defense.PersonalShieldThreat = (shield.ShieldMaxHealth or 0) * 0.01
                else
                    LOGOutput[id].Defense.EconomyThreatLevel = LOGOutput[id].Defense.EconomyThreatLevel + ((shieldarea - skirtarea) * (shield.ShieldMaxHealth or 0) * (shield.ShieldRegenRate or 1)) / 250000000
                end
            end

            --Define eco production values
            if bp.Economy.ProductionPerSecondMass then
                --Mass prod + 5% of health
                LOGOutput[id].Defense.EconomyThreatLevel = LOGOutput[id].Defense.EconomyThreatLevel + bp.Economy.ProductionPerSecondMass * 10 + (LOGOutput[id].Defense.HealthThreat + LOGOutput[id].Defense.PersonalShieldThreat) * 5
            end
            if bp.Economy.ProductionPerSecondEnergy then
                --Energy prod + 1% of health
                LOGOutput[id].Defense.EconomyThreatLevel = LOGOutput[id].Defense.EconomyThreatLevel + bp.Economy.ProductionPerSecondEnergy * 0.1 + LOGOutput[id].Defense.HealthThreat + LOGOutput[id].Defense.PersonalShieldThreat
            end
            --0 off the personal health values if we alreaady used them
            if bp.Economy.ProductionPerSecondMass or bp.Economy.ProductionPerSecondEnergy then
                LOGOutput[id].Defense.HealthThreat = 0
                LOGOutput[id].Defense.PersonalShieldThreat = 0
            end

            --Calculate for build rates, ignore things that only upgrade
            if ShouldWeCalculateBuildRate(bp) then
                --non-mass producing energy production units that can build get off easy on the health calculation. Engineering reactor, we're looking at you
                if bp.Physics.MotionType == 'RULEUMT_None' then
                    LOGOutput[id].Defense.EconomyThreatLevel = LOGOutput[id].Defense.EconomyThreatLevel + bp.Economy.BuildRate * 1 / (bp.Economy.BuilderDiscountMult or 1) * 2 + (LOGOutput[id].Defense.HealthThreat + LOGOutput[id].Defense.PersonalShieldThreat) * 2
                else
                    LOGOutput[id].Defense.EconomyThreatLevel = LOGOutput[id].Defense.EconomyThreatLevel + bp.Economy.BuildRate  + (LOGOutput[id].Defense.HealthThreat + LOGOutput[id].Defense.PersonalShieldThreat) * 3
                end
                --0 off the personal health values if we alreaady used them
                LOGOutput[id].Defense.HealthThreat = 0
                LOGOutput[id].Defense.PersonalShieldThreat = 0
            end

            --Calculate for storage values.
            if bp.Economy.StorageMass then
                LOGOutput[id].Defense.EconomyThreatLevel = LOGOutput[id].Defense.EconomyThreatLevel + bp.Economy.StorageMass * 0.001 + LOGOutput[id].Defense.HealthThreat + LOGOutput[id].Defense.PersonalShieldThreat
            end
            if bp.Economy.StorageEnergy then
                LOGOutput[id].Defense.EconomyThreatLevel = LOGOutput[id].Defense.EconomyThreatLevel + bp.Economy.StorageEnergy * 0.001 + LOGOutput[id].Defense.HealthThreat + LOGOutput[id].Defense.PersonalShieldThreat
            end
            --0 off the personal health values if we alreaady used them
            if bp.Economy.StorageMass or bp.Economy.StorageEnergy then
                LOGOutput[id].Defense.HealthThreat = 0
                LOGOutput[id].Defense.PersonalShieldThreat = 0
            end

            --Arbitrary high bonus threat for special high pri
            if table.find(bp.Categories, 'SPECIALHIGHPRI') then
                LOGOutput[id].Defense.EconomyThreatLevel = LOGOutput[id].Defense.EconomyThreatLevel + 250
            end

            --No one really cares about air staging, well maybe a little bit.
            if bp.Transport.DockingSlots then
                LOGOutput[id].Defense.EconomyThreatLevel = LOGOutput[id].Defense.EconomyThreatLevel + bp.Transport.DockingSlots
            end

            --Wepins
            if bp.Weapon then
                for i, weapon in bp.Weapon do
                    if weapon.RangeCategory == 'UWRC_AntiAir' or weapon.TargetRestrictOnlyAllow == 'AIR' or string.find(weapon.WeaponCategory or 'nope', 'Anti Air') then
                        LOGOutput[id].Defense.AirThreatLevel = LOGOutput[id].Defense.AirThreatLevel + CalculatedDPS(weapon) / 10
                    elseif weapon.RangeCategory == 'UWRC_AntiNavy' or string.find(weapon.WeaponCategory or 'nope', 'Anti Navy') then
                        if string.find(weapon.WeaponCategory or 'nope', 'Bomb') or string.find(weapon.Label or 'nope', 'Bomb') or weapon.NeedToComputeBombDrop or bp.Air.Winged then
                            LOG("Bomb drop damage value " .. CalculatedDamage(weapon))
                            LOGOutput[id].Defense.SubThreatLevel = LOGOutput[id].Defense.SubThreatLevel + CalculatedDamage(weapon) / 100
                        else
                            LOGOutput[id].Defense.SubThreatLevel = LOGOutput[id].Defense.SubThreatLevel + CalculatedDPS(weapon) / 10
                        end
                    elseif weapon.RangeCategory == 'UWRC_DirectFire' or string.find(weapon.WeaponCategory or 'nope', 'Direct Fire')
                    or weapon.RangeCategory == 'UWRC_IndirectFire' or string.find(weapon.WeaponCategory or 'nope', 'Artillery') then
                        --Range cutoff for artillery being considered eco and surface threat is 100
                        local wepDPS = CalculatedDPS(weapon)
                        local rangeCutoff = 50
                        local econMult = 1
                        local surfaceMult = 0.1
                        if weapon.MinRadius and weapon.MinRadius >= rangeCutoff then
                            LOGOutput[id].Defense.EconomyThreatLevel = LOGOutput[id].Defense.EconomyThreatLevel + wepDPS * econMult
                        elseif weapon.MaxRadius and weapon.MaxRadius <= rangeCutoff then
                            LOGOutput[id].Defense.SurfaceThreatLevel = LOGOutput[id].Defense.SurfaceThreatLevel + wepDPS * surfaceMult
                        else
                            local distr = (rangeCutoff - (weapon.MinRadius or 0)) / (weapon.MaxRadius - (weapon.MinRadius or 0))
                            LOGOutput[id].Defense.EconomyThreatLevel = LOGOutput[id].Defense.EconomyThreatLevel + wepDPS * (1 - distr) * econMult
                            LOGOutput[id].Defense.SurfaceThreatLevel = LOGOutput[id].Defense.SurfaceThreatLevel + wepDPS * distr * surfaceMult
                        end
                    elseif string.find(weapon.WeaponCategory or 'nope', 'Bomb') or string.find(weapon.Label or 'nope', 'Bomb') or weapon.NeedToComputeBombDrop then
                        LOG("Bomb drop damage value " .. CalculatedDamage(weapon))
                        LOGOutput[id].Defense.SurfaceThreatLevel = LOGOutput[id].Defense.SurfaceThreatLevel + CalculatedDamage(weapon) / 100
                    elseif string.find(weapon.WeaponCategory or 'nope', 'Death') then
                        LOGOutput[id].Defense.EconomyThreatLevel = math.floor(LOGOutput[id].Defense.EconomyThreatLevel + CalculatedDPS(weapon) / 200)
                    else
                        LOGOutput[id].Defense.UnknownWeaponThreat = LOGOutput[id].Defense.UnknownWeaponThreat + CalculatedDPS(weapon)
                        LOG(" * WARNING: Unknown weapon type on: " .. id .. " with the weapon label: " .. (weapon.Label or "nil") )
                        LOGOutput[id].Warnings = (LOGOutput[id].Warnings or 0) + 1
                    end
                    --LOG(id .. " - " .. LOC(bp.General.UnitName or bp.Description) .. ' -- ' .. (weapon.DisplayName or '<Unnamed weapon>') .. ' ' .. weapon.RangeCategory .. " DPS: " .. CalculatedDPS(weapon))
                end
            end

            --See if it has real threat yet
            local checkthreat = 0
            for k, v in { 'AirThreatLevel', 'EconomyThreatLevel', 'SubThreatLevel', 'SurfaceThreatLevel',} do
                checkthreat = checkthreat + LOGOutput[id].Defense[v]
            end

            --Last ditch attempt to give it some threat
            if checkthreat < 1 then
                if LOGOutput[id].Defense.UnknownWeaponThreat > 0 then
                    --If we have no idea what it is still, it has threat equal to its unkown weapon DPS.
                    LOGOutput[id].Defense.EconomyThreatLevel = LOGOutput[id].Defense.UnknownWeaponThreat
                    LOGOutput[id].Defense.UnknownWeaponThreat = 0
                elseif bp.Economy.MaintenanceConsumptionPerSecondEnergy > 0 then
                    --If we STILL have no idea what it's threat is, and it uses power, its obviously doing something fucky, so we'll use that.
                    LOGOutput[id].Defense.EconomyThreatLevel = bp.Economy.MaintenanceConsumptionPerSecondEnergy * 0.0175
                end
            end

            --Get rid of unused threat values
            for i, v in {'HealthThreat','PersonalShieldThreat', 'UnknownWeaponThreat'} do
                if LOGOutput[id].Defense[v] and LOGOutput[id].Defense[v] ~= 0 then
                    LOG("Unused " .. v .. " " .. LOGOutput[id].Defense[v])
                    LOGOutput[id].Defense[v] = nil
                end
            end

            --Sanitise the table
            checkthreat = 0
            for i, v in LOGOutput[id].Defense do
                --Round appropriately
                if v < 1 then
                    LOGOutput[id].Defense[i] = 0
                else
                    LOGOutput[id].Defense[i] = math.floor(v + 0.5)
                end
                --Only report numbers if they aren't the same as on file.
                if LOGOutput[id].Defense[i] == (bp.Defense[i] or 0) then
                    LOGOutput[id].Defense[i] = nil
                end
                if LOGOutput[id].Defense[i] then
                    checkthreat = checkthreat + LOGOutput[id].Defense[i]
                end
            end
            -- If we have nothing to tell, tell nothing.
            if checkthreat == 0 then
                LOGOutput[id] = nil
            end

        end
    end
    LOG(repr(LOGOutput))
end

function ShouldWeCalculateBuildRate(bp)
    if not bp.Economy.BuildRate then
        return false
    end
    if table.find(bp.Categories, 'HEAVYWALL') then
        return false
    end
    local TrueCats = {
        'FACTORY',
        'ENGINEER',
        'FIELDENGINEER',
        'CONSTRUCTION',
        'ENGINEERSTATION',
    }
    for i, v in TrueCats do
        if table.find(bp.Categories, v) then
            return true
        end
    end

    return not table.find(bp.Economy.BuildableCategory or {'nahh'}, bp.General.UpgradesTo or 'nope') and not bp.Economy.BuildableCategory[2]
end

function CalculatedDamage(weapon)
    local ProjectileCount = math.max(1, table.getn(weapon.RackBones[1].MuzzleBones or {'boop'} ), weapon.MuzzleSalvoSize or 1 )
    if weapon.RackFireTogether then
        ProjectileCount = ProjectileCount * math.max(1, table.getn(weapon.RackBones or {'boop'} ) )
    end
    return ((weapon.Damage or 0) + (weapon.NukeInnerRingDamage or 0)) * ProjectileCount * (weapon.DoTPulses or 1)
end

function CalculatedDPS(weapon)
    --Base values
    local ProjectileCount = math.max(1, table.getn(weapon.RackBones[1].MuzzleBones or {'boop'} ), weapon.MuzzleSalvoSize or 1 )
    if weapon.RackFireTogether then
        ProjectileCount = ProjectileCount * math.max(1, table.getn(weapon.RackBones or {'boop'} ) )
    end
    --Game logic rounds the timings to the nearest tick -- math.max(0.1, 1 / (weapon.RateOfFire or 1)) for unrounded values
    local DamageInterval = math.floor((math.max(0.1, 1 / (weapon.RateOfFire or 1)) * 10) + 0.5) / 10 + ProjectileCount * (math.max(weapon.MuzzleSalvoDelay or 0, weapon.MuzzleChargeDelay or 0) * (weapon.MuzzleSalvoSize or 1) )
    local Damage = ((weapon.Damage or 0) + (weapon.NukeInnerRingDamage or 0)) * ProjectileCount * (weapon.DoTPulses or 1)

    --Beam calculations.
    if weapon.BeamLifetime and weapon.BeamLifetime == 0 then
        --Unending beam. Interval is based on collision delay only.
        DamageInterval = 0.1 + (weapon.BeamCollisionDelay or 0)
    elseif weapon.BeamLifetime and weapon.BeamLifetime > 0 then
        --Uncontinuous beam. Interval from start to next start.
        DamageInterval = DamageInterval + weapon.BeamLifetime
        --Damage is calculated as a single glob
        Damage = Damage * (weapon.BeamLifetime / (0.1 + (weapon.BeamCollisionDelay or 0)))
    end

    return Damage * (1 / DamageInterval) or 0
end

function CheckUnitHasCorrectIconBackground(id, bp)
    local icon = string.lower(bp.General.Icon or 'land')
    local MT = bp.Physics.MotionType
    local BLC = bp.Physics.BuildOnLayerCaps -- LAYER_Air LAYER_Land
    local cats = bp.Categories
    local errorString = "unit: " .. id .. " (" .. LOC(bp.Description) .. ") has the wrong icon background (bp.General.Icon) reports: '" .. icon .. "' should be "

    if (
        MT == 'RULEUMT_Air' -- Fliers
        or MT == 'RULEUMT_None' and table.find(cats, 'FACTORY') and table.find(cats, 'AIR') --Aircraft factories
    ) then
        if icon ~= 'air' then
            LOG(errorString .. "'air'.")
            --LOG(repr(BLC))
        end
    elseif (
        MT == 'RULEUMT_Water' --Main two
        or MT == 'RULEUMT_SurfacingSub'
        or MT == 'RULEUMT_None' and not BLC.LAYER_Land and (BLC.LAYER_Seabed or BLC.LAYER_Sub or BLC.LAYER_Water) --buildings buildable in or on water, but not land
        or MT == 'RULEUMT_None' and table.find(cats, 'FACTORY') and table.find(cats, 'NAVAL') --Naval factories, if not specifically covered by the above, which they should be.
    ) then
        if icon ~= 'sea' then
            LOG(errorString .. "'sea'.")
            --LOG(repr(BLC))
        end
    elseif (
        (MT == 'RULEUMT_Hover' or MT == 'RULEUMT_AmphibiousFloating' or MT == 'RULEUMT_Amphibious' )
        or MT == 'RULEUMT_None' and BLC.LAYER_Land and (BLC.LAYER_Seabed or BLC.LAYER_Sub or BLC.LAYER_Water) --buildings buildable in or on water as well as on land.
    ) then
        if icon ~= 'amph' then
            LOG(errorString .. "'amph'.")
            --LOG(repr(BLC))
        end
    elseif (
        MT == 'RULEUMT_Land'
        or MT == 'RULEUMT_None' and BLC.LAYER_Land and not (BLC.LAYER_Seabed or BLC.LAYER_Sub or BLC.LAYER_Water) --buildings buildable on land, but not in or on the water.
    ) then
        if icon ~= 'land' then
            LOG(errorString .. "'land'.")
            --LOG(repr(BLC))
        end
    end
end

function LOC(s)
    if type(s) == 'string' and string.sub(s, 1, 4)=='<LOC' then
        local i = string.find(s,">")
        if i then
            s = string.sub(s, i+1)
        end
    end
    return s or 'nil'
end

function LOCref(s)
    if type(s) == 'string' and string.sub(s, 1, 4)=='<LOC' then
        local i = string.find(s,">")
        if i then
            s = string.sub(s, 6, i-1)
        end
    end
    return s or 'nil'
end


end
