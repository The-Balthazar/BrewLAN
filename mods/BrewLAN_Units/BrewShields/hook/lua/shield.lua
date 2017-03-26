--------------------------------------------------------------------------------
-- Projected shield script
-- Author: Sean 'Balthazar' Wheeldon based on code by John Comes & Gordon Duclos
--------------------------------------------------------------------------------
--local Entity = import('/lua/sim/Entity.lua').Entity
--local EffectTemplate = import('/lua/EffectTemplates.lua')
--local Util = import('utilities.lua')
--local Shield = import('/lua/shield.lua').Shield

ProjectedShield = Class(Shield){
    OnDamage =  function(self,instigator,amount,vector,type)
        --Count how many projectors are going to be recieving the damage.
        local pCount = self:CheckProjectors()
        --If there are none, then something has happened and we need to kill the shield.
        if pCount == 0 then
            self.Owner:DestroyShield()
        else
            ForkThread(self.CreateImpactEffect, self, vector)
            --Calculate the damage now, once, and before we fuck with the numbers.
            self:DistributeDamage(instigator,amount,vector,type)
        end
    end,

    CheckProjectors = function(self)
        local pCount = 0
        for i, projector in self.Owner.Projectors do
            if IsUnit(projector) and projector.MyShield and projector.MyShield:GetHealth() > 0 then
                pCount = pCount + 1
            --else
            --    self.Projectors[i] = nil
            end
        end
        return pCount
    end,

    DistributeDamage = function(self,instigator,amount,vector,type)
        local pCount = self:CheckProjectors()
        if pCount == 0 then
            self.Owner:OnDamage(instigator,amount,vector,type)
        end
        local damageToDeal = amount / pCount
        local overKillDamage, ProjectorHealth = 0,0
        for i, projector in self.Owner.Projectors do
            ProjectorHealth = projector.MyShield:GetHealth()
            projector.MyShield:OnDamage(instigator,damageToDeal,vector,type)
            --If it looked like too much damage, remove it from the projector list, and count the overkill
            if ProjectorHealth <= damageToDeal then
                overKillDamage = overKillDamage + math.max(damageToDeal - ProjectorHealth, 0)
                projector.ShieldProjectionEnabled = false
                projector:ClearShieldProjections()
            end
        end
        if overKillDamage > 0 then
            self:DistributeDamage(instigator,overKillDamage,vector,type)
        end
    end,

    CreateImpactEffect = function(self, vector)
        local army = self:GetArmy()
        local OffsetLength = Util.GetVectorLength(vector)
        local ImpactMesh = Entity { Owner = self.Owner }
        local beams = {}
        for i, Pillar in self.Owner.Projectors do
            beams[i] = AttachBeamEntityToEntity(self, 0, Pillar, 'Gem', self:GetArmy(), Pillar:GetBlueprint().Defense.Shield.ShieldTargetBeam)
        end
        Warp( ImpactMesh, self:GetPosition())
        if self.ImpactMeshBp != '' then
            ImpactMesh:SetMesh(self.ImpactMeshBp)
            ImpactMesh:SetDrawScale(self.Size)
            ImpactMesh:SetOrientation(OrientFromDir(Vector(-vector.x,-vector.y,-vector.z)),true)
        end
        for k, v in self.ImpactEffects do
            CreateEmitterAtBone( ImpactMesh, -1, army, v ):OffsetEmitter(0,0,OffsetLength)
        end
        WaitTicks(5)
        for i, v in beams do
            v:Destroy()
        end
        WaitTicks(45)
        ImpactMesh:Destroy()
    end,

    OnCollisionCheck = function(self,other)
        if self:CheckProjectors() == 0 then
            return false
        end
        return Shield.OnCollisionCheck(self,other)
    end,
}
