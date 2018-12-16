--------------------------------------------------------------------------------
-- Description : Armor definitions rock paper scissors script
--      Author : Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
do
    --[[First lets convert the table into something we can read input should look like:
        armordefinition = {
            {   -- Armor Type Name
                'Structure',

                -- Armor Definition
                'Normal 1.0',
                'Overcharge 0.066666',
                'Deathnuke 0.01',
            },
        }
    ]]
    local readArmor = {}
    for armorI, armor in armordefinition do
        for i = 2, table.getn(armor) do -- loop through the array, but skip 1
            if not readArmor[armor[1]] then readArmor[armor[1]] = {} end -- if we don't have a table named after the first in the array, make one
            local deliminator = string.find(armor[i], ' ') -- find where the deliminator in the definition is
            --create a key in the array named after everything before the space and populate it with everything after the space
            readArmor[armor[1]][string.sub(armor[i], 1, deliminator - 1)] = tonumber(string.sub(armor[i], deliminator + 1))
        end
    end
    --[[
        At this point we should have a table that looks like:
        readArmor = {
            Structure = {
                Normal = 1,
                Overcharge = 0.066666,
                Deathnuke = 0.01,
            }
        }
        no we need to extrapolate this into the rock/paper/scicors
    ]]
    --WARN(repr(readArmor))

    --Find the damage types table
    local DamageTypes = false
    for id, bp in __blueprints do
        if bp.DamageTypesRPSPassover then
            DamageTypes = bp.DamageTypesRPSPassover
            break
        end
    end
    --[[ the table should look like this, in no real order.
        DamageTypes = {
            'Normal',
            'OverCharge',
            'Deathnuke',
            'ExperimentalFootfall',
            ...
        }
    ]]
    local newarmordefinitions = {}

    local RPStable = {
        Rock = {
            Rock = 1,
            Paper = 4,
            Scissors = 0.25,
        },
        Paper = {
            Rock = 0.25,
            Paper = 1,
            Scissors = 4,
        },
        Scissors = {
            Rock = 4,
            Paper = 0.25,
            Scissors = 1,
        },
    }

    for Armor, Definition in readArmor do
        for rockArmor, rockDamageTable in RPStable do
            local NewDefinition = {
                Armor .. rockArmor,
            }
            for rockDamage, rockDamageValue in rockDamageTable do
                for i, damage in DamageTypes do
                    table.insert(NewDefinition, damage .. rockDamage .. ' ' .. (rockDamageValue * (Definition[damage] or 1)) )
                end
            end
            table.insert(newarmordefinitions, NewDefinition)
        end
    end
    --WARN(repr(newarmordefinitions))
    armordefinition = newarmordefinitions
end
