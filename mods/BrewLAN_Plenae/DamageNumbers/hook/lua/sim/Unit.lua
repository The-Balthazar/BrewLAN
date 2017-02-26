do
    --[[
    local Entity = import('/lua/sim/Entity.lua').Entity

    DamageMarker = Class(Entity) {
        __init = function(self, spec)
            LOG('DamageMarker')
            Entity.__init(self, spec)
            self.Position = spec.Position
            self.LifeTime = spec.LifeTime or 3
            self.Number = spec.Number
        end,

        OnCreate = function(self)
            Entity.OnCreate(self)
            LOG('DamageMarker OnCreate')
            Warp(self, self.Position)
            FloatingEntityText(self:GetEntityId(),string.rep(' ', math.random(0,5)) .. tostring(self.Number) .. string.rep(' ', math.random(0,5)))
            if self.LifeTime > 0 then
                self.LifeTimeThread = ForkThread(self.VisibleLifeTimeThread, self)
            end
        end,

        GetPosition = function(self)
             return self.Position
        end,

        VisibleLifeTimeThread = function(self)
            WaitSeconds(self.LifeTime)
            self:Destroy()
        end,

        OnDestroy = function(self)
            Entity.OnDestroy(self)
            if self.LifeTimeThread then
                self.LifeTimeThread:Destroy()
            end
        end
    }
    ]]--
    local UnitOld = Unit

    Unit = Class(UnitOld) {
        DoTakeDamage = function(self, instigator, amount, vector, damageType)
            --LOG(instigator:GetArmy())
            --[[
            local spec = {
                Position = self:GetPosition(),
                LifeTime = 3,
                Number = amount,
                Owner = instigator
            }   ]]--
            --DamageMarker(spec)

            if instigator and not instigator.Dead then
                FloatingEntityText(instigator:GetEntityId(),string.rep(' ', math.random(0,5)) .. tostring(amount) .. string.rep(' ', math.random(0,5)))
            end
            if self and not self.Dead then
                FloatingEntityText(self:GetEntityId(),string.rep(' ', math.random(0,5)) .. tostring(amount) .. string.rep(' ', math.random(0,5)))
            end
            UnitOld.DoTakeDamage(self, instigator, amount, vector, damageType)
        end,
    }
end
