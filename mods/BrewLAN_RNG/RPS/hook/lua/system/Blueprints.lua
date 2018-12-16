--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)
    OldModBlueprints(all_blueprints)

    RockPaperSorting(all_blueprints.Unit)
end

--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------

function RockPaperSorting(all_bps)
    local HostUnit = false
    for id, bp in all_bps do

        if not HostUnit then HostUnit = bp end

        local RPStable = {'Rock','Paper','Scissors'}
        local RPSchoice = RPStable[math.random(1,3)]

        if bp.Defense.ArmorType and type(bp.Defense.ArmorType) == 'string' then
            bp.Defense.ArmorType = bp.Defense.ArmorType .. RPSchoice
            if bp.Weapon then
                for i, weapon in bp.Weapon do
                    if weapon.DamageType and type(weapon.DamageType) == 'string' then
                        PassOverDamageTypes(HostUnit, weapon.DamageType)
                        weapon.DamageType = weapon.DamageType .. RPSchoice
                    end
                end
            end

            if type(bp.Display.MovementEffects.Land.Footfall.Damage.Type) == 'string' then
            --Should probably loop over more things with this one
                PassOverDamageTypes(HostUnit, bp.Display.MovementEffects.Land.Footfall.Damage.Type)
                bp.Display.MovementEffects.Land.Footfall.Damage.Type = bp.Display.MovementEffects.Land.Footfall.Damage.Type .. RPSchoice
            end

            if type(bp.Display.Abilities) == 'table' then
                table.insert(bp.Display.Abilities, '<LOC ability_' .. RPSchoice .. '>' .. RPSchoice)
            else
                bp.Display.Abilities = {
                    '<LOC ability_' .. RPSchoice .. '>' .. RPSchoice,
                }
            end
        end
    end
end

function PassOverDamageTypes(HostUnit, DamageType)
    if not HostUnit.DamageTypesRPSPassover then HostUnit.DamageTypesRPSPassover = {} end
    if not table.find(HostUnit.DamageTypesRPSPassover, DamageType) then
        table.insert(HostUnit.DamageTypesRPSPassover, DamageType)
    end
end

end
