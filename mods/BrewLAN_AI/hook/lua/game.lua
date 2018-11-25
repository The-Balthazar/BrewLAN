--------------------------------------------------------------------------------
-- Hook File: /lua/game.lua
--------------------------------------------------------------------------------
-- Modded By: Balthazar
--------------------------------------------------------------------------------
do
    --------------------------------------------------------------------------------
    -- Adapted from Manimal's mod locator script.
    -- Because I'm sick of people moaning when they put it in the wrong hole.
    -- Note to self: UID also in blueprints.lua and mod_info.lua
    --------------------------------------------------------------------------------
    BrewLANAIPath = function()
        for i, mod in __active_mods do
            if mod.uid == "25D57D85-7D84-27HT-A501-BR3WAI0000000" then
                return mod.location
            end
        end
    end
end
