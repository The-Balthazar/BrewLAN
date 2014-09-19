#****************************************************************************
#**
#**  File     :  /data/units/XAB3301/XAB3301_script.lua
#**  Author(s):  Jessica St. Croix, Ted Snook, Dru Staltman
#**
#**  Summary  :  Aeon Quantum Optics Facility Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local SStructureUnit = import('/lua/seraphimunits.lua').SStructureUnit

# Setup as RemoteViewing child of SStructureUnit
local RemoteViewing = import('/mods/BrewLAN/lua/RemoteViewing.lua').RemoteViewing
SStructureUnit = RemoteViewing( SStructureUnit )

SSB3301 = Class( SStructureUnit ) {
}

TypeClass = SSB3301