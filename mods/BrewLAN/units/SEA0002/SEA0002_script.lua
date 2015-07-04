#****************************************************************************
#**
#**  File     :  /cdimage/units/XEA0002/XEA0002_script.lua
#**  Author(s):  Drew Staltman, Gordon Duclos
#**
#**  Summary  :  UEF Defense Satelite Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local TAirUnit = import('/lua/terranunits.lua').TAirUnit
local TOrbitalDeathLaserBeamWeapon = import('/lua/terranweapons.lua').TOrbitalDeathLaserBeamWeapon
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker

SEA0002 = Class(TAirUnit) {
    DestroyNoFallRandomChance = 1.1,
    
    HideBones = { 'Shell01', 'Shell02', 'Shell03', 'Shell04', },
    
    Weapons = {
        OrbitalDeathLaserWeapon = Class(TOrbitalDeathLaserBeamWeapon){},
    },
    
    OnKilled = function(self, instigator, type, overkillRatio)
        if self.IsDying then 
            return 
        end
        self.IsDying = true    
        self.Parent.Satellite = nil
        self.Parent:Rebuild()
        --self.Parent.OpenState:Main(self.Parent)
        --ChangeState( self.Parent, self.Parent.OpenState )--self.Parent:Kill(instigator, type, 0)
        TAirUnit.OnKilled(self, instigator, type, overkillRatio)        
    end,
    
    Open = function(self)
        ChangeState( self, self.OpenState )
    end,
    
    OpenState = State() {
        Main = function(self)  
            self:SetMaintenanceConsumptionActive()
            self.OpenAnim = CreateAnimator(self)
            self.OpenAnim:PlayAnim( '/units/XEA0002/xea0002_aopen01.sca' )
            self.Trash:Add( self.OpenAnim )
            WaitFor( self.OpenAnim )
            
            self.OpenAnim:PlayAnim( '/units/XEA0002/xea0002_aopen02.sca' )
            
            for k,v in self.HideBones do
                self:HideBone( v, true )
            end
        end,
    },   
    
    OnIntelEnabled = function(self)
        TAirUnit.OnIntelEnabled(self)
        self:SetIntelRadius('vision', self:GetBlueprint().Intel.VisionRadius)   
        self:SetMaintenanceConsumptionActive()
    end,
            
    OnIntelDisabled = function(self)
        TAirUnit.OnIntelDisabled(self)      
        self:SetIntelRadius('vision', 5)   
        self:SetMaintenanceConsumptionInactive()
    end,
    --Make this unit invulnerable
   --OnDamage = function()
   --end,
}
TypeClass = SEA0002