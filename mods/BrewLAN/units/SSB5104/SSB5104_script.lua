#****************************************************************************
#**
#**  File     :  /cdimage/units/UAB5202/UAB5202_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Aeon Air Staging Platform
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local SAirStagingPlatformUnit = import('/lua/seraphimunits.lua').SAirStagingPlatformUnit
local SeraphimAirStagePlat02 = import('/lua/EffectTemplates.lua').SeraphimAirStagePlat02
local SeraphimAirStagePlat01 = import('/lua/EffectTemplates.lua').SeraphimAirStagePlat01

SSB5104 = Class(SAirStagingPlatformUnit) {
    OnStopBeingBuilt = function(self,builder,layer)
        for k, v in SeraphimAirStagePlat02 do
            CreateAttachedEmitter(self, 'BSB5104', self:GetArmy(), v):ScaleEmitter(0.3)
        end
        
        for k, v in SeraphimAirStagePlat01 do
            CreateAttachedEmitter(self, 'Pod01', self:GetArmy(), v):ScaleEmitter(0.8)
        end        

        SAirStagingPlatformUnit.OnStopBeingBuilt(self, builder, layer)
    end,
}

TypeClass = SSB5104
