do
    local Entity = import('/lua/sim/Entity.lua').Entity
    local EntityCategoryContains = EntityCategoryContains
    local IsEnemy = IsEnemy
    --------------------------------------------------------------------------------

    --------------------------------------------------------------------------------
    MissileDetector = Class(Entity) {
        OnCreate = function(self, spec)
            self.Owner = spec.Owner
            self:SetCollisionShape('Sphere', 0, 0, 0, spec.Radius)
            self:SetDrawScale(spec.Radius)
            self:AttachTo(spec.Owner, spec.AttachBone)
            self.Army = spec.Owner:GetArmy()
        end,

        OnCollisionCheck = function(self, other)
            if self.Owner:GetCurrentLayer() == 'Air'
            and EntityCategoryContains(categories.MISSILE * categories.ANTIAIR, other)
            --and other ~= self.EnemyProj
            and IsEnemy(self.Army, other:GetArmy()) and self.Owner.DeployFlares then
                self.Owner:DeployFlares()
            end
            return false
        end,
    }
    --------------------------------------------------------------------------------

    --------------------------------------------------------------------------------
    AAFlare = Class(Entity) {

        OnCreate = function(self, spec)
            ------------------------------------------------------------------------
            -- Set up basic data
            ------------------------------------------------------------------------
            self.Owner = spec.Owner
            self.Radius = spec.Radius or 5
            self.Army = spec.Owner:GetArmy()
            ------------------------------------------------------------------------
            -- Warp where we need to be
            ------------------------------------------------------------------------
            Warp(self, spec.Owner:GetPosition(spec.AttachBone))
            ------------------------------------------------------------------------
            -- Define collision
            ------------------------------------------------------------------------
            self:SetCollisionShape('Sphere', 0, 0, 0, self.Radius)
            self:SetDrawScale(self.Radius)
            ------------------------------------------------------------------------
            -- Effects and life
            ------------------------------------------------------------------------
            local effect = CreateAttachedEmitter(self, -1, self.Army, '/effects/emitters/aeon_missiled_wisp_04_emit.bp')
            ForkThread(function()
                WaitTicks(3)
                effect:ScaleEmitter(3)
                WaitTicks((spec.LifeTime or 20) - 3)
                self:Destroy()
            end)
        end,

        -- We only divert projectiles, and wait for them to time out.
        OnCollisionCheck = function(self,other)
            if EntityCategoryContains(categories.MISSILE * categories.ANTIAIR, other) and self.Army ~= other:GetArmy() then
                other:SetNewTarget(self)
                other:SetTurnRate(540)--720)
            end
            return false
        end,
    }
end
