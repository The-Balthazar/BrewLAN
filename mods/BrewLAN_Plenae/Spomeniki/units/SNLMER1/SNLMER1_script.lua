--Most of this is from the UEF tech 1 generator, becase there didn't seem a point writing it all again.
local TConstructionUnit = import('/lua/terranunits.lua').TConstructionUnit

SNLMER1 = Class(TConstructionUnit) {
    OnStopBeingBuilt = function(self,builder,layer)
        TConstructionUnit.OnStopBeingBuilt(self, builder, layer)
        self:SetMaintenanceConsumptionActive()
        ChangeState(self, self.OpeningState)  --This will cause an issue if it's built by a factory.
    end,

    OnIntelDisabled = function(self)
        TConstructionUnit.OnIntelDisabled(self)
        self.IntelEnabled = false
    end,

    OnIntelEnabled = function(self)
        TConstructionUnit.OnIntelEnabled(self)
        self.IntelEnabled = true
    end,

    OnDestroy = function(self)
        TConstructionUnit.OnDestroy(self)
        ChangeState(self, self.DeadState)
    end,

    OpeningState = State {
        Main = function(self)
            self:SetProductionPerSecondEnergy( self:GetBlueprint().Economy.ProductionPerSecondEnergy * 0.5 )
            if self:GetBlueprint().Audio.Activate then
                self:PlaySound(self:GetBlueprint().Audio.Activate)
            end

            if not self.Animator then
                self.Animator = CreateAnimator(self):PlayAnim(self:GetBlueprint().Display.AnimationOpen):SetRate(1)
                self.Trash:Add(self.Animator)
            end

            self.Animator:SetRate(1)
            WaitFor(self.Animator)
            ChangeState(self, self.IdleOpenState)
        end,

        OnDamage = function(self, instigator, amount, vector, damageType)
            TConstructionUnit.OnDamage(self, instigator, amount, vector, damageType)
            self.DamageSeconds = 10
            ChangeState(self, self.ClosingState)
        end,
    },

    IdleOpenState = State {
        Main = function(self)
            self:SetProductionPerSecondEnergy( self:GetBlueprint().Economy.ProductionPerSecondEnergy )
            if not self.Dish then
                --CreateRotator(unit, bone, axis, [goal], [speed], [accel], [goalspeed])
                self.Dish = CreateRotator(self, 'Antenna_HG_Dish', 'x', nil, 9, 9)
                self.Trash:Add(self.Dish)
            end
            while true do
                if self.IntelEnabled then
                    self.Dish:SetGoal(40)
                    WaitFor(self.Dish)
                end
                if self.IntelEnabled then
                    self.Dish:SetGoal(-40)
                    WaitFor(self.Dish)
                else
                    WaitSeconds(1)
                end
            end
        end,

        OnDamage = function(self, instigator, amount, vector, damageType)
            TConstructionUnit.OnDamage(self, instigator, amount, vector, damageType)
            self.DamageSeconds = 10
            ChangeState(self, self.ClosingState)
        end,
    },

    ClosingState = State {
        Main = function(self)
            self:SetProductionPerSecondEnergy( self:GetBlueprint().Economy.ProductionPerSecondEnergy * 0.5 )
            if self.Dish then
                self.Dish:SetGoal(0)
            end
            if self.Animator then
                self.Animator:SetRate(-1)
                WaitFor(self.Animator)
            end
            ChangeState(self, self.ClosedIdleState)
        end,

        OnDamage = function(self, instigator, amount, vector, damageType)
            TConstructionUnit.OnDamage(self, instigator, amount, vector, damageType)
            self.DamageSeconds = 10
        end,
    },

    ClosedIdleState = State {
        Main = function(self)
            self:SetProductionPerSecondEnergy( 0 )
            while self.DamageSeconds > 0 do
                WaitSeconds(1)
                self.DamageSeconds = self.DamageSeconds - 1
            end
            ChangeState(self, self.OpeningState)
        end,

        OnDamage = function(self, instigator, amount, vector, damageType)
            TConstructionUnit.OnDamage(self, instigator, amount, vector, damageType)
            self.DamageSeconds = 10
        end,
    },

    DeadState = State {
        Main = function(self) end,
    },
}

TypeClass = SNLMER1
