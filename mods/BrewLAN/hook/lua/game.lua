--------------------------------------------------------------------------------
-- Hook File: /lua/game.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do
    local OldGetConstructEconomyModel = GetConstructEconomyModel

    function GetConstructEconomyModel(builder, targetData, ...)
        local builder_bp = builder:GetBlueprint()

        if builder_bp.BlueprintId == targetData.HalfPriceUpgradeFromID
        or builder_bp.General.UpgradesTo == targetData.HalfPriceUpgradeFromID
        or builder_bp.Economy.BuilderDiscountMult
        then
            local build, energy, mass = OldGetConstructEconomyModel(builder, targetData, unpack(arg))
            local discount = targetData.UpgradeFromCostDiscount or builder_bp.Economy.BuilderDiscountMult or 0.5

            return build, energy * discount, mass * discount
        else
            return OldGetConstructEconomyModel(builder, targetData, unpack(arg))
        end
    end

    --------------------------------------------------------------------------------
    -- Adapted from Manimal's mod locator script.
    -- Because I'm sick of people moaning when they put it in the wrong hole.
    --------------------------------------------------------------------------------
    local GetBrewLANPath = function() for i, mod in __active_mods do if mod.name == "BrewLAN" then return mod.location end end end
    BrewLANPath = GetBrewLANPath()
end
