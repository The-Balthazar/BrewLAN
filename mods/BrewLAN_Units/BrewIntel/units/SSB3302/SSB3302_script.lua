local SRadarUnit = import('/lua/seraphimunits.lua').SRadarUnit
local AnimationThread = import('/lua/effectutilities.lua').IntelDishAnimationThread

SSB3302 = Class(SRadarUnit) {

    OnStopBeingBuilt = function(self, ...)
        SRadarUnit.OnStopBeingBuilt(self, unpack(arg) )
        self:ForkThread(AnimationThread,{
            {
                'Tower_Orb',
                'Tower_Orb',
                --c = 1,
                bounds = {-180,180,-15,50,},
                speed = 3,
            },
        })
    end,

    OnIntelEnabled = function(self)
        SRadarUnit.OnIntelEnabled(self)
        self.Intel = true

        if not self.Rotors then
            self.Rotors = {}
            for i, v in {'Radar_Orb_001', 'Radar_Orb_002', 'Radar_Orb_003'} do
                --CreateRotator(unit, bone, axis, [goal], [speed], [accel], [goalspeed])
                self.Rotors[i] = CreateRotator(self, v, 'x', 0, 20, 0.024):SetAccel(0.00001)
                self.Trash:Add(self.Rotors[i])
                self:ForkThread(
                    function(self, rotor)
                        while not self.Dead do
                            if self.Intel then
                                rotor:SetGoal(math.random(-59, 59))
                            end
                            coroutine.yield(math.random(30, 90))
                        end
                    end,
                    self.Rotors[i]
                )
            end
        end
    end,

    OnIntelDisabled = function(self)
        SRadarUnit.OnIntelDisabled(self)
        self.Intel = nil
    end,

    DeathThread = function(self)
        --Destroy the custom anim rotors
        if self.Rotors then
            for i, v in self.Rotors do
                v:Destroy()
                LOG("YEET")
            end
        end
        --Destroy the pitch control rotor from the effect util anims
        if self.Rotators and self.Rotators[1] and self.Rotators[1][2] and self.Rotators[1][2].Destroy then
            self.Rotators[1][2]:Destroy()
            self.Rotators[1][1]:SetGoal(self.Rotators[1][1]:GetCurrentAngle())
            LOG("LIKE SO YEET")
        end
        SRadarUnit.DeathThread(self)
    end,
}

TypeClass = SSB3302
