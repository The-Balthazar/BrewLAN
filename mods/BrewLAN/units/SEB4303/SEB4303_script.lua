--------------------------------------------------------------------------------
--  Summary  :  UEF Heavy Shield Generator Script
--------------------------------------------------------------------------------
local TShieldStructureUnit = import('/lua/terranunits.lua').TShieldStructureUnit

SEB4303 = Class(TShieldStructureUnit) {

    ShieldEffects = {
        '/effects/emitters/terran_shield_generator_t2_01_emit.bp',
        '/effects/emitters/terran_shield_generator_T3_02_emit.bp',
    },

    OnStopBeingBuilt = function(self,builder,layer)
        TShieldStructureUnit.OnStopBeingBuilt(self,builder,layer)
        self.Rotators = {
            CreateRotator(self, 'TurretA', 'z', 0, 10, 5, 0),
            CreateRotator(self, 'TurretB', 'z', 0, 10, 5, 0),
            CreateRotator(self, 'TurretA_Barrel', 'x', 0, 10, 5, 0),
            CreateRotator(self, 'TurretB_Barrel', 'x', 0, 10, 5, 0),
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
		self.ShieldEffectsBag = {}
    end,

    OnShieldEnabled = function(self)
        TShieldStructureUnit.OnShieldEnabled(self)
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
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
		    self.ShieldEffectsBag = {}
		end
    end,

}

TypeClass = SEB4303
