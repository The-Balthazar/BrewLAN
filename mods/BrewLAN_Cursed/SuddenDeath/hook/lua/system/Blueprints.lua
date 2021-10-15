--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)
    OldModBlueprints(all_blueprints)

    SuddenDeath(all_blueprints.Unit)
end

--------------------------------------------------------------------------------
-- KNIVES!
--------------------------------------------------------------------------------

function SuddenDeath(all_bps)
    local RegularWeapon = function(weapon, bp)
        return weapon.RangeCategory ~= 'UWRC_Countermeasure'
    end
    local setThings = function(bp,num)
        if bp.Defense.MaxHealth and bp.Defense.Health then
            bp.Defense.MaxHealth = num
            bp.Defense.Health = num
            bp.Defense.RegenRate = math.floor((num/20)+0.5)
        end
        if bp.Defense.Shield.ShieldMaxHealth and bp.Defense.Shield.ShieldMaxHealth ~= 1 then
            bp.Defense.Shield.ShieldMaxHealth = num
            bp.Defense.Shield.ShieldRegenRate = 1 + math.floor((num/20)+0.5)
        end
    end
    for id, bp in all_bps do
        if bp.Defense.MaxHealth and bp.Defense.Health then
            if table.find(bp.Categories, 'TECH1') then
                setThings(bp,2)
            elseif table.find(bp.Categories, 'TECH2') then
                setThings(bp,4)
            elseif table.find(bp.Categories, 'TECH3') and bp.Defense.MaxHealth < 5000 then
                setThings(bp,6)
            elseif table.find(bp.Categories, 'TECH3') and bp.Defense.MaxHealth >= 5000 then
                setThings(bp,8)
            elseif table.find(bp.Categories, 'EXPERIMENTAL') then
                setThings(bp,10)
            else
                setThings(bp,20)
            end
        end
        if bp.Weapon then
            for i, weapon in bp.Weapon do
                if RegularWeapon(weapon, bp) then
                    weapon.Damage = 2
                end
            end
        end
    end
end

end
