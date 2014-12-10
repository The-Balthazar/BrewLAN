#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB1103/UEB1103_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Tier 1 Mass Extractor Script
#**
#**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local UEB1103 = import('/units/ueb1103/ueb1103_script.lua').UEB1103
local AiTrix = import('/mods/MetalWorld/lua/MookBuild.lua').AiTrix
local TMassCollectionUnit = AiTrix(UEB1103)

UEB1103 = Class(TMassCollectionUnit) {
}

TypeClass = UEB1103