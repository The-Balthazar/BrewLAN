--------------------------------------------------------------------------------
--  Summary:  AI cheating script
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
local URB1103 = import('/units/urb1103/urb1103_script.lua').URB1103
local AiTrix = import('/mods/BrewLAN_Gameplay/MetalWorld/lua/MookBuild.lua').AiTrix
local TMassCollectionUnit = AiTrix(URB1103)

URB1103 = Class(TMassCollectionUnit) {
}

TypeClass = URB1103
