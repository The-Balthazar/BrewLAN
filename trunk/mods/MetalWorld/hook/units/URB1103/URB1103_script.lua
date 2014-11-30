#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB1103/UEB1103_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Tier 1 Mass Extractor Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local URB1103 = import('/units/urb1103/urb1103_script.lua').URB1103
local AiTrix = import('/mods/MetalWorld/lua/MookBuild.lua').AiTrix
local TMassCollectionUnit = AiTrix(URB1103)

URB1103 = Class(TMassCollectionUnit) {
}

TypeClass = URB1103