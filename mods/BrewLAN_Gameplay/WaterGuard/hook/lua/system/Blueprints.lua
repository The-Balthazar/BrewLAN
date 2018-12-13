--------------------------------------------------------------------------------
-- Hook File: /lua/system/blueprints.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do

local OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)         
    OldModBlueprints(all_blueprints)
    
    WaterGuard(all_blueprints.Unit)
end

--------------------------------------------------------------------------------
-- Define splashy above water weapons as normalabovewater
--------------------------------------------------------------------------------

function WaterGuard(all_bps)
    for id, bp in all_bps do
        if table.find(bp.Categories, 'SELECTABLE') and bp.Weapon then
            for i, weap in bp.Weapon do
                if weap.AboveWaterTargetsOnly and weap.DamageRadius and weap.DamageRadius > 1 and weap.DamageType == 'Normal' then
                    weap.DamageType = 'NormalAboveWater'
                end 
            end 
        end
    end
end

end