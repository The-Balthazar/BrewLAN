local SStructureUnit = import('/lua/seraphimunits.lua').SStructureUnit
local RemoteViewing = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/RemoteViewing.lua').RemoteViewing
SStructureUnit = RemoteViewing( SStructureUnit )

SSB3301 = Class( SStructureUnit ) {
}

TypeClass = SSB3301
