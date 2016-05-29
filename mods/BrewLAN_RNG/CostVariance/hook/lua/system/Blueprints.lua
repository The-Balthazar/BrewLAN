--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)         
    OldModBlueprints(all_blueprints)
    
    CostVariance(all_blueprints.Unit)
end

--------------------------------------------------------------------------------
-- Allowing many buildings to be buildable in/on the water
--------------------------------------------------------------------------------

function CostVariance(all_bps)
    for id, bp in all_bps do
        if bp.Economy.BuildCostEnergy and bp.Economy.BuildCostMass and bp.Economy.BuildTime and not table.find(bp.Categories, 'ECONOMIC') then
            local rand1 = math.random(50000,150000)/100000
            local rand2 = math.random(50000,150000)/100000
            local rand3 = (rand1 + rand2)/2
            
            bp.Economy.BuildCostEnergy = math.ceil((bp.Economy.BuildCostEnergy or 0) * rand1)
            bp.Economy.BuildCostMass = math.ceil((bp.Economy.BuildCostMass or 0) * rand2)
            bp.Economy.BuildTime = math.ceil((bp.Economy.BuildTime or 0) * rand3)
            if bp.Defense.Health and bp.Defense.MaxHealth then 
                bp.Defense.Health = math.ceil((bp.Defense.Health or 0) * rand2)
                bp.Defense.MaxHealth = math.ceil((bp.Defense.MaxHealth or 0) * rand2) 
            end
            if bp.Defense.Shield.ShieldMaxHealth then
                bp.Defense.Shield.ShieldMaxHealth = math.ceil((bp.Defense.Shield.ShieldMaxHealth or 0) * rand2)
                if bp.Defense.Shield.ShieldSize and bp.Defense.Shield.ShieldSize > 4 then
                    local offset = bp.Defense.Shield.ShieldSize - ((bp.Defense.Shield.ShieldSize or 0) * ((rand2 + 4) / 5))
                    bp.Defense.Shield.ShieldSize = (bp.Defense.Shield.ShieldSize or 0) * ((rand2 + 4) / 5)
                    bp.Defense.Shield.ShieldVerticalOffset = (bp.Defense.Shield.ShieldVerticalOffset or 0) + offset 
                end         
            end
            if bp.Physics.MaxSpeed then
                bp.Physics.MaxSpeed = (bp.Physics.MaxSpeed or 0) * rand3
            end
            if bp.Economy.BuildRate then
                bp.Economy.BuildRate = math.ceil((bp.Economy.BuildRate or 0) * rand3) 
            end
            if bp.Weapon then
                for i, weapon in bp.Weapon do
                    if weapon.MaxRadius then
                        bp.Weapon[i].MaxRadius = (bp.Weapon[i].MaxRadius or 0) * rand1
                    end
                end
            end
        end
    end
end
    
end
