#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB1103/UEB1103_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Tier 1 Mass Extractor Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local XSB1103 = import('/units/xsb1103/xsb1103_script.lua').XSB1103
local AiTrix = import('/mods/MetalWorld/lua/MookBuild.lua').AiTrix
local TMassCollectionUnit = AiTrix(XSB1103)

XSB1103 = Class(TMassCollectionUnit) {
}

TypeClass = XSB1103