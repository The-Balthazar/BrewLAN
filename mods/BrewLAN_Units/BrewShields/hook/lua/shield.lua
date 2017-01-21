--------------------------------------------------------------------------------
-- Projected shield script
-- Author: Sean 'Balthazar' Wheeldon based on code by John Comes & Gordon Duclos
--------------------------------------------------------------------------------
--local Entity = import('/lua/sim/Entity.lua').Entity
--local EffectTemplate = import('/lua/EffectTemplates.lua')
--local Util = import('utilities.lua')
--local Shield = import('/lua/shield.lua').Shield

ProjectedShield = Class(Shield){
    Projectors = {},

    OnDamage =  function(self,instigator,amount,vector,type)
        --local absorbed = self:OnGetDamageAbsorption(instigator,amount,type)

        if self.PassOverkillDamage then
            local overkill = self:GetOverkill(instigator,amount,type)
            if self.Owner and IsUnit(self.Owner) and overkill > 0 then
                self.Owner:DoTakeDamage(instigator, overkill, vector, type)
            end
        end

        local pCount = 0
        for i, projector in self.Projectors do
            if IsUnit(projector) and projector.MyShield:GetHealth() > 0 then
                pCount = pCount + 1
            else
                self.Projectors[i] = nil
            end
        end
        if pCount == 0 then
            self.Owner:DestroyShield()
        else
            for i, projector in self.Projectors do
                projector.MyShield:OnDamage(instigator,amount / pCount,vector,type)
                --projector.MyShield:AdjustHealth(instigator, -absorbed)
            end
        end
        --self:AdjustHealth(instigator, -absorbed)
        --self:UpdateShieldRatio(-1)

        --LOG('Shield Health: ' .. self:GetHealth())
        if self.RegenThread then
            KillThread(self.RegenThread)
            self.RegenThread = nil
        end
        if self:GetHealth() <= 0 then
            ChangeState(self, self.DamageRechargeState)
        else
            if self.OffHealth < 0 then
                ForkThread(self.CreateImpactEffect, self, vector)
                if self.RegenRate > 0 then
                    self.RegenThread = ForkThread(self.RegenStartThread, self)
                    self.Owner.Trash:Add(self.RegenThread)
                end
            else
                self:UpdateShieldRatio(0)
            end
        end
    end,
}
