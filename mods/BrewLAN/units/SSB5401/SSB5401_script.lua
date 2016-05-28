--------------------------------------------------------------------------------
-- Summary  :  Stargate Script
--------------------------------------------------------------------------------    
local SQuantumGateUnit = import('/lua/seraphimunits.lua').SQuantumGateUnit
local StargateDialing = import(import( '/lua/game.lua' ).BrewLANPath() .. '/lua/StargateDialing.lua').StargateDialing
SQuantumGateUnit = StargateDialing(SQuantumGateUnit) 

SSB5401 = Class(SQuantumGateUnit) {

}

TypeClass = SSB5401
