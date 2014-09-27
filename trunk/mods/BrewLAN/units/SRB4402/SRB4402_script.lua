#****************************************************************************
#**
#**  File     :  /cdimage/units/URB4203/URB4203_script.lua
#**  Author(s):  David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Radar Jammer Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CRadarJammerUnit = import('/lua/cybranunits.lua').CRadarJammerUnit  
local BareBonesWeapon = import('/lua/sim/defaultweapons.lua').BareBonesWeapon 
local Utilities = import('/lua/utilities.lua')

SRB4402 = Class(CRadarJammerUnit) {    
    Weapons = {
        PulseWeapon = Class(BareBonesWeapon) {
            OnFire = function(self)
                local aiBrain = self.unit:GetAIBrain()      
                local Mypos = self.unit:GetPosition()
                local Range = self.MaxRadius or 2000
                local LocalUnits = aiBrain:GetUnitsAroundPoint(categories.ALLUNITS, Mypos, Range)
                for k, v in LocalUnits do
                    if self.unit:GetEntityId() != v:GetEntityId()                    --Check its not this unit (if this somehow gains omni?)
                    and v:IsIntelEnabled('Omni') then                                --Check it actually has Omni enabled. 
                        if not self.unit.Nerfed then self.unit.Nerfed = {} end       --Create the table if it doesn't exist.
                        if not self.unit.Nerfed[v] then                              --If the target hasn't been affected by this.
                            if not v.DarknessCount then
                                v.DarknessCount = 1                                  --Counts how many of these are affecting this
                                v.Darkness = v:GetIntelRadius('Omni')
                                self.unit.Nerfed[v] = v:GetIntelRadius('Omni')
                            else
                                v.DarknessCount = v.DarknessCount + 1 
                                self.unit.Nerfed[v] = v.Darkness
                            end
                        elseif v:GetIntelRadius('Omni') > self.unit.Nerfed[v] or v.Darkness < v:GetIntelRadius('Omni') then -- checking the target hasn't upgraded or something.      
                            self.unit.Nerfed[v] = v:GetIntelRadius('Omni')
                            v.Darkness = v:GetIntelRadius('Omni')
                        end
                        if v:GetIntelRadius('Omni') > 50 then
                            rate = 0.4 + Utilities.GetDistanceBetweenTwoEntities(v, self.unit)/(Range*2)
                            v:SetIntelRadius('Omni', math.max(v:GetIntelRadius('Omni')*rate, 50))
                            v:RequestRefreshUI()
                        end
                    end
                end
            end,
        },
    },
    
    OnScriptBitSet = function(self, bit)
        CRadarJammerUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
            self:GetWeaponByLabel('PulseWeapon'):FireWeapon()
        end
    end,
    
    OnIntelEnabled = function(self)
        CRadarJammerUnit.OnIntelEnabled(self)
    end,

    OnIntelDisabled = function(self)
        self.ReturnOmni()
        CRadarJammerUnit.OnIntelDisabled(self)
    end,
       
    OnKilled = function(self, instigator, type, overkillRatio)
        self.ReturnOmni()
        CRadarJammerUnit.OnKilled(self, instigator, type, overkillRatio)
    end,
    
    ReturnOmni = function(self)
        if self.Nerfed then
            for k, v in self.Nerfed do
                if k:GetIntelRadius('Omni') < v and k.DarknessCount == 1 then        --If no other of these are affecting this and its omni is less than last check, return its omni.
                    k:SetIntelRadius('Omni', v)
                end 
                k.DarknessCount = k.DarknessCount - 1
                v = nil
            end
        end
    end,   
     
    IntelEffects = {
        {
            Bones = {
            	0,
            },
            Offset = {
              	0,
              	0,
              	0,
            },
            Type = 'Jammer01',
        },
    },
}
TypeClass = SRB4402