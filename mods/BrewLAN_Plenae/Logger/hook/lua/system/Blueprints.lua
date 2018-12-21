--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)
    OldModBlueprints(all_blueprints)

    CheckAllUnitBackgroundImages(all_blueprints.Unit)
    CheckAllUnitThreatValues(all_blueprints.Unit)
    CheckCollisionSphereLargeEnoughForMaxSpeed(all_blueprints.Unit)
    FindUnusedFiles(all_blueprints.Unit)
end

--------------------------------------------------------------------------------
-- Logs
--------------------------------------------------------------------------------

function ShouldWeLogThis(id, bp)
    --[[local units = {
        'sal0320',
        'uaa0310',
        'sea0401',
        'url0203',
    }
    return units and table.find(units, id)]]
    return --[[table.find(bp.Categories, 'SELECTABLE') and]] (table.find(bp.Categories, 'PRODUCTBREWLAN') or table.find(bp.Categories, 'PRODUCTBREWLANTURRETS') or table.find(bp.Categories, 'PRODUCTBREWLANSHIELDS') or table.find(bp.Categories, 'PRODUCTBREWLANRND') or table.find(bp.Categories, 'PRODUCTSPOMENIKI'))
    --return table.find(bp.Categories, 'SELECTABLE') and (table.find(bp.Categories, 'TECH1') or table.find(bp.Categories, 'TECH2') or table.find(bp.Categories, 'TECH3') or table.find(bp.Categories, 'EXPERIMENTAL') )
end

function CheckAllUnitBackgroundImages(all_bps)
    for id, bp in all_bps do
        CheckUnitHasCorrectIconBackground(id, bp)
    end
end

function CheckCollisionSphereLargeEnoughForMaxSpeed(all_bps)
    for id, bp in all_bps do
    	if bp.SizeSphere and bp.Air.MaxAirspeed and ShouldWeLogThis(id, bp) then
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

end
