--------------------------------------------------------------------------------
--  Summary  :  Seraphim T3 Mobile Radar Script
--------------------------------------------------------------------------------
local SRadarUnit = import('/lua/seraphimunits.lua').SRadarUnit
local SHoverLandUnit = import('/lua/seraphimunits.lua').SHoverLandUnit

SSL0324 = Class(SHoverLandUnit) {
    OnCreate = function(self)
        self.FxBlinkingLightsBag = {}
        SHoverLandUnit.OnCreate(self)
    end,

    OnIntelDisabled = function(self)
        SRadarUnit.OnIntelDisabled(self)
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        SRadarUnit.OnStopBeingBuilt(self,builder,layer)
        --self:SetMaintenanceConsumptionActive()
    end,

    CreateTarmac = function(self)
        --WTFFAF
    end,

    OnIntelEnabled = function(self)
        SRadarUnit.OnIntelEnabled(self)
        if not self.Rotator then
            self.Rotator = CreateRotator(self, 'Array', 'y')
            self.Trash:Add(self.Rotator1)
        end

        self.Rotator:SetTargetSpeed(30)
        self.Rotator:SetAccel(20)
    end,

    PlayActiveAnimation = function(self)
        if SRadarUnit.PlayActiveAnimation then
            SRadarUnit.PlayActiveAnimation(self)
        end
    end,

    CreateBlinkingLights = function(self, color)
        if SRadarUnit.CreateBlinkingLights then
            SRadarUnit.CreateBlinkingLights(self, color)
        end
    end,

    DestroyBlinkingLights = function(self)
        if SRadarUnit.DestroyBlinkingLights then
            SRadarUnit.DestroyBlinkingLights(self)
        end
    end,
}

TypeClass = SSL0324
