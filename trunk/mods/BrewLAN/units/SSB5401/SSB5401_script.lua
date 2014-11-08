#****************************************************************************
#**
#**  File     :  /cdimage/units/XSB0304/XSB0304_script.lua
#**  Author(s):  Greg Kohne
#**
#**  Summary  :  Seraphim Sub Commander Gateway Unit Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
#
# script for UAB0304
#
local SQuantumGateUnit = import('/lua/seraphimunits.lua').SQuantumGateUnit
--local SSeraphimSubCommanderGateway01 = import('/lua/EffectTemplates.lua').SeraphimSubCommanderGateway01
--local SSeraphimSubCommanderGateway02 = import('/lua/EffectTemplates.lua').SeraphimSubCommanderGateway02
--local SSeraphimSubCommanderGateway03 = import('/lua/EffectTemplates.lua').SeraphimSubCommanderGateway03

SSB5401 = Class(SQuantumGateUnit) {

    OnStopBeingBuilt = function(self,builder,layer)
        ###Place emitters at the center of the gateway.
if false then
        for k, v in SSeraphimSubCommanderGateway01 do
            CreateAttachedEmitter(self, 0, self:GetArmy(), v)
        end
        
        ###Place emitters on certain light bones on the mesh.
        for k, v in SSeraphimSubCommanderGateway02 do
            CreateAttachedEmitter(self, 0, self:GetArmy(), v)
            CreateAttachedEmitter(self, 0, self:GetArmy(), v)
            CreateAttachedEmitter(self, 0, self:GetArmy(), v)
        end
        
        ###Place emitters on certain OTHER light bones on the mesh.
        for k, v in SSeraphimSubCommanderGateway03 do
            CreateAttachedEmitter(self, 0, self:GetArmy(), v)
            CreateAttachedEmitter(self, 0, self:GetArmy(), v)
            CreateAttachedEmitter(self, 0, self:GetArmy(), v)
            CreateAttachedEmitter(self, 0, self:GetArmy(), v)
            CreateAttachedEmitter(self, 0, self:GetArmy(), v)
            CreateAttachedEmitter(self, 0, self:GetArmy(), v)
        end
end        

        SQuantumGateUnit.OnStopBeingBuilt(self, builder, layer)
    end,
}

TypeClass = SSB5401
