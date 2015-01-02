--------------------------------------------------------------------------------
-- Summary  :  Stargate Script
--------------------------------------------------------------------------------    
local SQuantumGateUnit = import('/lua/seraphimunits.lua').SQuantumGateUnit
local StargateDialing = import('/mods/BrewLAN/lua/StargateDialing.lua').StargateDialing
SQuantumGateUnit = StargateDialing(SQuantumGateUnit) 

SSB5401 = Class(SQuantumGateUnit) {

}

TypeClass = SSB5401
