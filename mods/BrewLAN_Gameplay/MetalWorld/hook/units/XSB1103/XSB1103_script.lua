--------------------------------------------------------------------------------
--  Summary:  AI cheating script
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
local XSB1103 = import('/units/xsb1103/xsb1103_script.lua').XSB1103
local AiTrix = import('/mods/BrewLAN_Gameplay/MetalWorld/lua/MookBuild.lua').AiTrix
local TMassCollectionUnit = AiTrix(XSB1103)

XSB1103 = Class(TMassCollectionUnit) {
}

TypeClass = XSB1103
