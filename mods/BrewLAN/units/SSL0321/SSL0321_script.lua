#****************************************************************************
#**
#**  File     :  /cdimage/units/XSL0111/XSL0111_script.lua
#**  Author(s):  Drew Staltman, Gordon Duclos
#**
#**  Summary  :  Seraphim Mobile Missile Launcher Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local SLandUnit = import('/lua/seraphimunits.lua').SLandUnit
local SIFHuAntiNukeWeapon = import('/lua/seraphimweapons.lua').SIFHuAntiNukeWeapon

SSL0321 = Class(SLandUnit) {
    Weapons = {
        MissileRack = Class(SIFHuAntiNukeWeapon) {
            OnWeaponFired = function(self)
                self.unit:ForkThread(self.unit.HideMissile)   
            end,
        },
    },

    OnStopBeingBuilt = function(self,builder,layer)
        SLandUnit.OnStopBeingBuilt(self,builder,layer)
        local bp = self:GetBlueprint()
        local missileBone = bp.Display.MissileBone
        if missileBone then
            if not self.MissileSlider then
                self.MissileSlider = CreateSlider(self, missileBone)
                self.Trash:Add(self.MissileSlider)
            end        
        end
    end,

    OnSiloBuildStart = function(self, weapon)
        self.MissileBuilt = false
        SLandUnit.OnSiloBuildStart(self, weapon)
    end,
    
    OnSiloBuildEnd = function(self, weapon)
        self.MissileBuilt = true          
        SLandUnit.OnSiloBuildEnd(self,weapon)  
        self:ForkThread(self.RaiseMissile)     
    end,
    
    RaiseMissile = function(self)
        self.NotCancelled = true
        WaitSeconds(0.1)
        local missileBone = self:GetBlueprint().Display.MissileBone
        if missileBone and self.NotCancelled then
            self:ShowBone(missileBone, true)
            if self.MissileSlider then
                self.MissileSlider:SetGoal(0, 0, 0)
                self.MissileSlider:SetSpeed(10)
            end
        end     
    end,
    
    HideMissile = function(self)
        WaitSeconds(0.1)
        self:RetractMissile()
    end,
    
    RetractMissile = function(self)
        local missileBone = self:GetBlueprint().Display.MissileBone
        if missileBone then
            self:HideBone(missileBone, true)
            if self.MissileSlider then
                self.MissileSlider:SetSpeed(400)
                self.MissileSlider:SetGoal(0,0,-20)
            end
        end              
    end,
}
TypeClass = SSL0321
