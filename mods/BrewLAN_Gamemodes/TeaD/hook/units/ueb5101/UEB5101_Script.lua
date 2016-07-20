local TWallStructureUnit = UEB5101

UEB5101 = Class(TWallStructureUnit) {
    RegenDelay = function(self)
        WaitSeconds(1)
        while self:GetHealth() < self:GetMaxHealth() do
            if GetGameTimeSeconds() > (self.DamageTime or GetGameTimeSeconds() ) + 1 then
                self:SetHealth(self, self:GetHealth() + 50)
            end
            WaitTicks(1)
        end
        self.DamageTime = nil
        KillThread(self.RegenDelayThread) 
    end,
    
    OnDamage = function(self, instigator, amount, vector, damageType, ...)
        self.DamageTime = GetGameTimeSeconds()
        if not self.RegenDelayThread then
            self.RegenDelayThread = self:ForkThread(self.RegenDelay)
        end
        TWallStructureUnit.OnDamage(self, instigator, amount, vector, damageType, unpack(arg))
    end,
}

TypeClass = UEB5101