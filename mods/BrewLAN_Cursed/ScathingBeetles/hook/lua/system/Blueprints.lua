--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do
    local OldModBlueprints = ModBlueprints
    function ModBlueprints(all_blueprints)
        OldModBlueprints(all_blueprints)
        BEEETLES(all_blueprints.Unit)
    end
    --------------------------------------------------------------------------------
    -- KNIVES!
    --------------------------------------------------------------------------------

    function BeetlesLocation()
        for i, mod in __active_mods do
            if mod.uid == "16678e1e-7fc9-11e5-8bcf-scathingbe20" then
                return mod.location
            end
        end
    end

    function BEEETLES(all_bps)
        for _, id in {'url0401', 'srb2401'} do
            local bp = all_bps[id]
            if bp then
                for i, weapon in bp.Weapon do
                    if not weapon.WeaponCategory ~= 'Death'
                    and string.lower(weapon.ProjectileId or 'nope') == '/projectiles/cifartilleryproton01/cifartilleryproton01_proj.bp' then
                        weapon.ProjectileId = BeetlesLocation() .. '/projectiles/CIFArtilleryBeetles01/CIFArtilleryBeetles01_proj.bp'
                    end
                end
            end
        end
    end
end
