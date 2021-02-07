--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)
    OldModBlueprints(all_blueprints)

    BuiltByTeaD(all_blueprints.Unit)
end

--------------------------------------------------------------------------------
-- Gief turrets
--------------------------------------------------------------------------------

function BuiltByTeaD(all_bps)
    for id, bp in all_bps do
        --Make sure it's a structure that's probably touchable
        if table.find(bp.Categories, 'STRUCTURE')
        and table.find(bp.Categories, 'SELECTABLE')
        and table.find(bp.Categories, 'DRAGBUILD')
        --Make sure it can't produce
        and not (bp.Economy and bp.Economy.ProductionPerSecondMass)
        and not (bp.Economy and bp.Economy.BuildableCategory) --probably add a check to allow upgradeable
        --Make sure it's got weapons
        and bp.Weapon
        and bp.Weapon[1]
        --Make sure it's only weapon isn't a death weapon
        and not (bp.Weapon[1].Label == 'DeathWeapon' and not bp.Weapon[2])
        then
            for i, cat in {'TECH1', 'TECH2', 'TECH3', 'EXPERIMENTAL'} do
                if table.find(bp.Categories, cat) then
                    for j = math.min(i, 3), 3 do
                        --LOG("Giving "..id.." the category "..'BUILTBYTIER'..j..'TEAD')
                        table.insert(bp.Categories, 'BUILTBYTIER'..j..'TEAD')
                    end
                end
            end
        end
    end
end

end
