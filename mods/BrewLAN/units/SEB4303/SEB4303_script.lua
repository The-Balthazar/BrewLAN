#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB4301/UEB4301_script.lua
#**  Author(s):  John Comes, Greg Kohne
#**
#**  Summary  :  UEF Heavy Shield Generator Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TShieldStructureUnit = import('/lua/terranunits.lua').TShieldStructureUnit

SEB4303 = Class(TShieldStructureUnit) {
    
    ShieldEffects = {
        '/effects/emitters/terran_shield_generator_t2_01_emit.bp',
        '/effects/emitters/terran_shield_generator_T3_02_emit.bp',
        --'/effects/emitters/terran_shield_generator_t2_03_emit.bp',
    },
    
    OnStopBeingBuilt = function(self,builder,layer)
        TShieldStructureUnit.OnStopBeingBuilt(self,builder,layer)
        self.Rotators = {
            CreateRotator(self, 'Turret001', 'z', 0, 10, 5, 0),
            CreateRotator(self, 'Turret002', 'z', 0, 10, 5, 0),
            CreateRotator(self, 'Turret_barrel001', 'x', 0, 10, 5, 0),
            CreateRotator(self, 'Turret_barrel002', 'x', 0, 10, 5, 0),
        }
        self:ForkThread(
            function()
                while true do
                    if self:ShieldIsOn() then
                        local pointer = math.random(1,2)
                        local speed = math.random(0,1) * math.random(10,100)
                        local goalyaw = math.random(-360,360)
                        local goal = math.random(-40,35)
                        self.Rotators[pointer]:SetGoal(goalyaw):SetSpeed(speed)-- * (-1 + 2 * math.random(0, 1)) )
                        self.Rotators[pointer + 2]:SetGoal(goal):SetSpeed(speed)
                        WaitTicks(math.random(1,10) )
                    else
                        WaitSeconds(5)
                    end
                end
            end
        )
        
        --self.Trash:Add(self.Rotator1)
        --self.Trash:Add(self.Rotator2)
		self.ShieldEffectsBag = {}
    end,

    OnShieldEnabled = function(self)
        TShieldStructureUnit.OnShieldEnabled(self)
        --if self.Rotator1 then
        --    self.Rotator1:SetTargetSpeed(10)
        --end
        --if self.Rotator2 then
        --    self.Rotator2:SetTargetSpeed(-10)
        --end
        
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
		    self.ShieldEffectsBag = {}
		end
        for k, v in self.ShieldEffects do
            table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 0, self:GetArmy(), v ):OffsetEmitter(0,2,-3.3) )
        end
    end,

    OnShieldDisabled = function(self)
        TShieldStructureUnit.OnShieldDisabled(self)
        --self.Rotator1:SetTargetSpeed(0)
        --self.Rotator2:SetTargetSpeed(0)
        
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
		    self.ShieldEffectsBag = {}
		end
    end,

}

TypeClass = SEB4303
