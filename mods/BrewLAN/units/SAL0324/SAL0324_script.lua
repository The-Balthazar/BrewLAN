--------------------------------------------------------------------------------
--  Summary:  Aeon Mobile Radar script
--   Author:  Sean 'Balthazar' Wheeldon
--------------------------------------------------------------------------------
local ALandUnit = import('/lua/aeonunits.lua').ALandUnit

SAL0324 = Class(ALandUnit) {

    OnStopBeingBuilt = function(self, builder, layer)
        ALandUnit.OnStopBeingBuilt(self, builder, layer)
        self:SetMaintenanceConsumptionActive()
    end,

    OnIntelEnabled = function(self)
        ALandUnit.OnIntelEnabled(self)
        self:CreateActiveAnimation(true)
        self.Intel = true
    end,

    OnIntelDisabled = function(self)
        ALandUnit.OnIntelDisabled(self)
        self:CreateActiveAnimation(false)
        self.Intel = nil
    end,

    TransportAnimation = function(self, rate)
        ALandUnit.TransportAnimation(self, rate)
        if not rate or rate > 0 then
            --picked up
            self:CreateActiveAnimation(false, true)
        elseif rate < 0 then
            --dropped
            self:CreateActiveAnimation(self.Intel)
        end
    end,

    CreateActiveAnimation = function(self, active, refresh)
        if self.AnimActive and refresh then
            self.AnimActive:Destroy()
            self.AnimActive = nil
        end
        if not self.AnimActive then
            self.AnimActive = CreateAnimator(self)
            self.Trash:Add(self.AnimActive:PlayAnim(self:GetBlueprint().Display.AnimationActive, true):SetRate(0))
        end
        if active then
            self.AnimActive:SetRate(0.25)
        else
            self.AnimActive:SetRate(0)
        end
    end,
}

TypeClass = SAL0324
