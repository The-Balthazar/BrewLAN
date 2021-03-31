--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)
    OldModBlueprints(all_blueprints)

    BrewLANPersonalShieldCategory(all_blueprints.Unit)
end

--------------------------------------------------------------------------------
-- This fixes GAZ_UI asuming that just because it has a shield that the unit knows how good it is.
--------------------------------------------------------------------------------

function BrewLANPersonalShieldCategory(all_bps)
    for id, bp in all_bps do
        if bp.Categories and bp.Defense and bp.Defense.Shield then
            if (bp.Defense.Shield.PersonalShield or math.max(bp.Defense.Shield.ShieldSize, bp.Defense.Shield.ShieldProjectionRadius or 0) < math.max(bp.SizeX or 1, bp.SizeY or 1, bp.SizeZ or 1) + 3) and table.find(bp.Categories, 'SHIELD') then
                table.removeByValue(bp.Categories, 'SHIELD')
            end
            if not table.find(bp.Categories, 'SHIELD') and not table.find(bp.Categories, 'PERSONALSHIELD') then
                table.insert(bp.Categories, 'PERSONALSHIELD')
            end
        end
        if bp.Weapon then
            for i, wep in bp.Weapon do
                if wep.TargetPriorities and wep.DamageToShields and wep.DamageToShields > (wep.Damage or 0) * 10 then
                    if wep.DamageToShields > (wep.Damage or 0) * 100 then
                        wep.TargetPriorities = {
                            'SHIELD',
                            'PERSONALSHIELD',
                            'ALLUNITS',
                        }
                    else
                        wep.TargetPriorities = {
                            'SPECIALHIGHPRI',
                            'SHIELD',
                            'PERSONALSHIELD',
                            'DEFENSE',
                            'SPECIALLOWPRI',
                            'ALLUNITS',
                        }
                    end
                end
            end
        end
    end
end

end
