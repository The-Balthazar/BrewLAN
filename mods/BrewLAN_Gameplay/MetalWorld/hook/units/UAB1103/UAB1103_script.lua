--------------------------------------------------------------------------------
--  Summary:  AI cheating script
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
local UAB1103 = import('/units/uab1103/uab1103_script.lua').UAB1103
local AiTrix = import('/mods/BrewLAN_Gameplay/MetalWorld/lua/MookBuild.lua').AiTrix
local TMassCollectionUnit = AiTrix(UAB1103)

UAB1103 = Class(TMassCollectionUnit) {
}

TypeClass = UAB1103
