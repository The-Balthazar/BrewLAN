--------------------------------------------------------------------------------
--  Summary:  AI cheating script
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
local UEB1103 = import('/units/ueb1103/ueb1103_script.lua').UEB1103
local AiTrix = import('/mods/BrewLAN_Gameplay/MetalWorld/lua/MookBuild.lua').AiTrix
local TMassCollectionUnit = AiTrix(UEB1103)

UEB1103 = Class(TMassCollectionUnit) {
}

TypeClass = UEB1103
