#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB1103/UEB1103_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Tier 1 Mass Extractor Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local UAB1103 = import('/units/uab1103/uab1103_script.lua').UAB1103
local AiTrix = import('/mods/MetalWorld/lua/MookBuild.lua').AiTrix
local TMassCollectionUnit = AiTrix(UAB1103)

UAB1103 = Class(TMassCollectionUnit) {
}

TypeClass = UAB1103