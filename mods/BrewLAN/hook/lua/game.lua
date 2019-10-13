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
    -- Note to self: UID also in blueprints.lua and mod_info.lua
    --------------------------------------------------------------------------------
    BrewLANPath = function()
        for i, mod in __active_mods do
            if mod.uid == "25D57D85-7D84-27HT-A501-BR3WL4N000089" then
                return mod.location
            end
        end
    end
end
