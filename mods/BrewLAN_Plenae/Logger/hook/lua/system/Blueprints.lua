--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)
    OldModBlueprints(all_blueprints)

    LoggerGonnaLog(all_blueprints.Unit)
end

--------------------------------------------------------------------------------
-- Logs
--------------------------------------------------------------------------------

function LoggerGonnaLog(all_bps)
    local units = {
        'sal0320',
        'uaa0310',
        'sea0401',
        'url0203',
    }
    for id, bp in all_bps do
    --for i, id in units do local bp = all_bps[id]
        if bp.Weapon then
            for i, weapon in bp.Weapon do
                ------------------------------------------------------------
                -- Damage per second calculation
                ------------------------------------------------------------
                local function RealDPS(weapon)
                    --Base values
                    local ProjectileCount = math.max(1, table.getn(weapon.RackBones[1].MuzzleBones or {'boop'} ) )
                    --Game logic rounds the timings to the nearest tick -- math.max(0.1, 1 / (weapon.RateOfFire or 1)) for unrounded values
                    local DamageInterval = math.floor((math.max(0.1, 1 / (weapon.RateOfFire or 1)) * 10) + 0.5) / 10 + ProjectileCount * math.max(weapon.MuzzleSalvoDelay or 0, weapon.MuzzleChargeDelay or 0)
                    local Damage = ((weapon.Damage or 0) + (weapon.NukeInnerRingDamage or 0)) * ProjectileCount

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

                    return Damage * (1 / DamageInterval)
                end
                LOG((bp.General.UnitName or id) .. '--' .. (weapon.DisplayName or 'No name gun') .. ": " .. RealDPS(weapon))
            end
        end
    end
end

end
