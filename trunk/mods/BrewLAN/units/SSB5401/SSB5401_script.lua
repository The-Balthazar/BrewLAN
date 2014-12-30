--------------------------------------------------------------------------------
-- Summary  :  Stargate Script
--------------------------------------------------------------------------------    
local SQuantumGateUnit = import('/lua/seraphimunits.lua').SQuantumGateUnit
local StargateDailing = import('/mods/BrewLAN/lua/StargateDialing.lua').StargateDialing
SQuantumGateUnit = StargateDailing(SQuantumGateUnit) 

SSB5401 = Class(SQuantumGateUnit) {

}

TypeClass = SSB5401
