--------------------------------------------------------------------------------
--  Summary  :  UEF Torpedo Bomber Script
--------------------------------------------------------------------------------
local TAirUnit = import('/lua/terranunits.lua').TAirUnit
local Twepins = import('/lua/terranweapons.lua')
local TANTorpedoAngler = Twepins.TANTorpedoAngler
local TAirToAirLinkedRailgun = Twepins.TAirToAirLinkedRailgun

SEA0307 = Class(TAirUnit) {
    Weapons = {
        Torpedo = Class(TANTorpedoAngler) {},
        LinkedRailGun = Class(TAirToAirLinkedRailgun) {},
    },

    OnStopBeingBuilt = function(self,builder,layer)
        TAirUnit.OnStopBeingBuilt(self,builder,layer)
        self.LandingAnimManip = CreateAnimator(self):SetPrecedence(0):PlayAnim(self:GetBlueprint().Display.AnimationLand):SetRate(1)
    end,

    OnMotionVertEventChange = function(self, new, old)
        TAirUnit.OnMotionVertEventChange(self, new, old)
        if new == 'Down' and self.LandingAnimManip then
            self.LandingAnimManip:SetRate(-1)
        elseif new == 'Up' or new == 'Top' and self.LandingAnimManip then
            self.LandingAnimManip:SetRate(1)
        end
    end,

    OnLayerChange = function(self, new, old)
        TAirUnit.OnLayerChange(self, new, old)
        if (new == 'Land' or new == 'Water') and self.LandingAnimManip then
            self.LandingAnimManip:SetRate(-1)
        elseif new == 'Air' and self.LandingAnimManip then
            self.LandingAnimManip:SetRate(1)
        end
    end,
}

TypeClass = SEA0307
