--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)
    OldModBlueprints(all_blueprints)

    ExperimentalIconOverhaul(all_blueprints.Unit)
end

--------------------------------------------------------------------------------
-- Icon modifications the hardcore way. May make a UI only version later.
--------------------------------------------------------------------------------

function ExperimentalIconOverhaul(all_bps)
    local units = {
        --ssb5401 = 'icon_experimental_structure_transport',
    }
    for id, bp in all_bps do
        ------------------------------------------------------------------------
        -- Check for pre-defined overrides
        ------------------------------------------------------------------------
        if bp.StrategicIconName == 'icon_experimental_generic' and (bp.StrategicIconNameEIOOverride or units[id]) then
            bp.StrategicIconName = units[id] or bp.StrategicIconNameEIOOverride
        end
        if bp.StrategicIconName == 'icon_experimental_generic' and bp.Categories and type(bp.Categories[1]) == "string" then
            local icon = 'icon_experimental_'
            --------------------------------------------------------------------
            -- Define background shape
            --------------------------------------------------------------------
            if table.find(bp.Categories, 'AIR') and table.find(bp.Categories, 'MOBILE') then
                if bp.Air.Winged then
                    icon = icon .. 'bomber_'
                elseif not bp.Air.Winged then
                    icon = icon .. 'gunship_'
                end
            elseif table.find(bp.Categories, 'STRUCTURE') and bp.Physics.MotionType == 'RULEUMT_None' then
                if table.find(bp.Categories, 'FACTORY') then
                    icon = icon .. 'factory_'
                else
                    icon = icon .. 'structure_'
                end
            elseif table.find(bp.Categories, 'NAVAL') and table.find(bp.Categories, 'MOBILE') then
                if table.find(bp.Categories, 'SUBMERSIBLE') then
                    icon = icon .. 'sub_'
                else
                    icon = icon .. 'ship_'
                end
            elseif table.find(bp.Categories, 'LAND') and table.find(bp.Categories, 'MOBILE') then
                if table.find(bp.Categories, 'FACTORY') then
                    icon = icon .. 'mobilefactory_'
                else
                    icon = icon .. 'land_'
                end
            end
            --------------------------------------------------------------------
            -- Define the foreground icon
            --------------------------------------------------------------------
            local iconbackup = icon
            if table.find(bp.Categories, 'FIELDENGINEER') or table.find(bp.Categories, 'ENGINEER') then
                icon = icon .. 'engineer'
            elseif table.find(bp.Categories, 'TRANSPORTATION') then
                icon = icon .. 'transport'
            elseif table.find(bp.Categories, 'ANTIARTILLERY') then
                icon = icon .. 'antiartillery'
            elseif table.find(bp.Categories, 'ANTISHIELD') then
                icon = icon .. 'antishield'
            elseif table.find(bp.Categories, 'COUNTERINTELLIGENCE') and (bp.Intel.CloakFieldRadius or bp.Intel.RadarStealthFieldRadius or bp.Intel.SonarStealthFieldRadius) then --Prioritise counterintel over weapon if it has a field generator
                icon = icon .. 'counterintel'
            elseif (
                table.find(bp.Categories, 'DIRECTFIRE')
                or table.find(bp.Categories, 'GROUNDATTACK')
                or table.find(bp.Categories, 'ANTIAIR')
                or table.find(bp.Categories, 'ANTINAVY')
                or table.find(bp.Categories, 'BOMBER')
                or table.find(bp.Categories, 'ARTILLERY')
                or table.find(bp.Categories, 'INDIRECTFIRE')
                or table.find(bp.Categories, 'MISSILE')
                or table.find(bp.Categories, 'NUKE')
                or table.find(bp.Categories, 'SILO')
            )
            and bp.Weapon then
                --FIGHT FOR YOUR ICON! LITERALLY!
                local layer = {
                    air = {0, 'antiair'},
                    artillery = {0, 'artillery'},
                    land = {0, 'directfire'},
                    naval = {0, 'antinavy'},
                    missile = {0, 'missile'},
                    kamikaze = {0, 'bomb'},
                }
                for i, weapon in bp.Weapon do
                    ------------------------------------------------------------
                    -- Damage per second calculation, biased towards high damage
                    ------------------------------------------------------------
                    local function DPS(weapon)
                        --Base values
                        local bias = 1.2
                        local ProjectileCount = math.max(1, table.getn(weapon.RackBones[1].MuzzleBones or {'boop'} ) )
                        if weapon.RackFireTogether then
                            ProjectileCount = ProjectileCount * math.max(1, table.getn(weapon.RackBones or {'boop'} ) )
                        end
                        local DamageInterval = math.floor((math.max(0.1, 1 / (weapon.RateOfFire or 1)) * 10) + 0.5) / 10  + ProjectileCount * math.max(weapon.MuzzleSalvoDelay or 0, weapon.MuzzleChargeDelay or 0)
                        local Damage = ((weapon.Damage or 0) + (weapon.NukeInnerRingDamage or 0)) * ProjectileCount

                        if weapon.BeamLifetime and weapon.BeamLifetime == 0 then
                            DamageInterval = 0.1 + (weapon.BeamCollisionDelay or 0)
                            return math.pow(Damage * (1 / DamageInterval), bias)  --Apply Bias to full second of continuous beams
                        elseif weapon.BeamLifetime and weapon.BeamLifetime > 0 then
                            DamageInterval = DamageInterval + weapon.BeamLifetime
                            Damage = Damage * (weapon.BeamLifetime / (0.1 + (weapon.BeamCollisionDelay or 0) )) --Calculate damage as across the whole beam for non-continuous beams
                        end

                        return math.pow(Damage, bias) * (1 / DamageInterval)
                    end
                    ------------------------------------------------------------
                    -- String sanitisation and case desensitising
                    ------------------------------------------------------------
                    local function SAN(stringtosan)
                        if type(stringtosan) == 'string' then
                            return string.lower(stringtosan)
                        else
                            return 'unknowntype'
                        end
                    end
                    local sanWcat = SAN(weapon.WeaponCategory)
                    local sanRcat = SAN(weapon.RangeCategory)
                    if string.find(sanWcat, 'anti air') or sanRcat == 'uwrc_antiair' then
                        layer.air[1] = layer.air[1] + DPS(weapon)
                    elseif sanRcat == 'uwrc_indirectfire' or string.find(sanWcat, 'indirect fire') or string.find(sanWcat, 'artillery') or string.find(sanWcat, 'missile') then
                        if string.find(sanWcat, 'indirect fire') or string.find(sanWcat, 'artillery') then
                            layer.artillery[1] = layer.artillery[1] + DPS(weapon)
                        elseif string.find(sanWcat, 'missile') then
                            layer.missile[1] = layer.missile[1] + DPS(weapon)
                        end
                    elseif (string.find(sanWcat, 'direct fire') or string.find(sanWcat, 'bomb')) or sanRcat == 'uwrc_directfire' then
                        layer.land[1] = layer.land[1] + DPS(weapon)
                    elseif string.find(sanWcat, 'anti navy') or sanRcat == 'uwrc_antinavy' then
                        layer.naval[1] = layer.naval[1] + DPS(weapon)
                    elseif string.find(sanWcat, 'kamikaze') then
                        layer.kamikaze[1] = layer.kamikaze[1] + DPS(weapon)
                    end
                end
                local best = {0, 'directfire'}
                for l, data in layer do
                    if data[1] > best[1] then best = data end
                end
                icon = icon .. best[2]
            elseif table.find(bp.Categories, 'ANTIMISSILE') then
                icon = icon .. 'antimissile'
            elseif table.find(bp.Categories, 'COUNTERINTELLIGENCE') then
                icon = icon .. 'counterintel'
            elseif table.find(bp.Categories, 'CARRIER') or table.find(bp.Categories, 'AIRSTAGINGPLATFORM') then
                icon = icon .. 'air'
            elseif table.find(bp.Categories, 'DEFENSE') and table.find(bp.Categories, 'SHIELD') then
                icon = icon .. 'shield'
            elseif table.find(bp.Categories, 'STARGATE') then
                icon = icon .. 'transport'
            elseif table.find(bp.Categories, 'INTELLIGENCE') then
                icon = icon .. 'intel'
            elseif table.find(bp.Categories, 'ECONOMIC') then
                if table.find(bp.Categories, 'MASSPRODUCTION') or table.find(bp.Categories, 'MASSFABRICATION') then
                    icon = icon .. 'mass'
                elseif table.find(bp.Categories, 'ENERGYPRODUCTION') then
                    icon = icon .. 'energy'
                else
                    icon = icon .. 'generic'
                end
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
                            if string.find(buildcat, layer) then
                                bits[i] = '1'
                                break
                            end
                        end
                    end
                end
                local sbits = table.concat(bits)
                if sbits == '100' then
                    icon = icon .. 'land'
                elseif sbits == '010' then
                    icon = icon .. 'air'
                elseif sbits == '001' then
                    icon = icon .. 'naval'
                else
                    icon = icon .. 'generic'
                end
            else
                icon = icon .. 'generic'
            end
            bp.StrategicIconName = icon
        end
    end
end

end
