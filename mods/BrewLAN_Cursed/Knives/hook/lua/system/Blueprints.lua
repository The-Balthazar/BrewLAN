--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)
    OldModBlueprints(all_blueprints)

    KnivesAtDawn(all_blueprints.Unit)
end

--------------------------------------------------------------------------------
-- KNIVES!
--------------------------------------------------------------------------------

function KnivesAtDawn(all_bps)
    local NormalKnifeWeapon = function(weapon, bp)
        return weapon.WeaponCategory ~= 'Death' and not weapon.NeedToComputeBombDrop and not ((table.find(bp.Categories, 'STRUCTURE') or table.find(bp.Categories, 'LAND') or table.find(bp.Categories, 'NAVAL') ) and weapon.RangeCategory == 'UWRC_AntiAir' ) and weapon.RangeCategory ~= 'UWRC_Countermeasure'
    end
    for id, bp in all_bps do
        local SizeMult = 1 / (bp.Display.UniformScale or 1)
        local Size = math.max((bp.SizeX or 1),(bp.SizeZ or 1))
        if bp.Weapon then
            for i, weapon in bp.Weapon do
                if NormalKnifeWeapon(weapon, bp) then
                    if (weapon.MuzzleSalvoDelay or 0) == 0 then
                        weapon.RackRecoilDistance = 2 * SizeMult * (Size * 0.5)--math.max(math.abs(weapon.RackRecoilDistance),1) * 10
                    end
                    weapon.MaxRadius = Size + 2
                    weapon.MinRadius = nil
                    weapon.KNIFE = true
                    --weapon.DamageRadius = 1
                end
            end
        end
    end
end

end
