local Unit = import('/lua/sim/Unit.lua').Unit

Creep = Class(Unit) {
    OnStopBeingBuilt = function(self,builder,layer)
        Unit.OnStopBeingBuilt(self,builder,layer)
        self:ForkThread(function()
            WaitSeconds(1)
            IssueClearCommands({self})
            if self.Target then
                --IssueMove({self}, GetArmyBrain(self.Target):GetArmyStartPos())
                IssueMove({self}, GetArmyBrain(self.Target).LifeCrystalPos )
            else
                IssueMove({self}, {ScenarioInfo.size[1]/2, 0, ScenarioInfo.size[2]/2})
            end
            local pos
            local newpos
            while true do
                pos = self:GetPosition()
                WaitSeconds(10)
                newpos = self:GetPosition()
                if VDist2Sq(pos[1], pos[3], newpos[1], newpos[3]) < .05 then
                    if self.Target then
                        IssueMove({self}, GetArmyBrain(self.Target).LifeCrystalPos )
                    else
                        IssueMove({self}, {ScenarioInfo.size[1]/2, 0, ScenarioInfo.size[2]/2})
                    end
                end
            end
        end)
        self:ForkThread(function()
            while true do
                walls = self:GetAIBrain():GetUnitsAroundPoint( categories.WALL, self:GetPosition(), 2)
                if walls[1] then
                    for i, wall in walls do
                        --wall:Destroy()
                        wall:OnDamage(self, 50, Vector(0,0,0), 'normal')    
                    end
                    WaitTicks(1)
                else
                    WaitSeconds(1)
                end 
            end
        end)      
    end,
         
    WalkingAnim = nil,
    WalkingAnimRate = 1,
    IdleAnim = false,
    IdleAnimRate = 1,
    DeathAnim = false,
    DisabledBones = {},

    OnMotionHorzEventChange = function( self, new, old )
        Unit.OnMotionHorzEventChange(self, new, old)
        if EntityCategoryContains(categories.WALKER, self) then
            if ( old == 'Stopped' ) then
                if (not self.Animator) then
                    self.Animator = CreateAnimator(self, true)
                end
                local bpDisplay = self:GetBlueprint().Display
                if bpDisplay.AnimationWalk then
                    self.Animator:PlayAnim(bpDisplay.AnimationWalk, true)
                    self.Animator:SetRate(bpDisplay.AnimationWalkRate or 1)
                end
            elseif ( new == 'Stopped' ) then
                --only keep the animator around if we are dying and playing a death anim
                --or if we have an idle anim
                if(self.IdleAnim and not self:IsDead()) then
                    self.Animator:PlayAnim(self.IdleAnim, true)
                elseif(not self.DeathAnim or not self:IsDead()) then
                    self.Animator:Destroy()
                    self.Animator = false
                end
            end
        end
    end,
    
    OnKilled = function(self, instigator, type, overkillRatio)
        instigator:GetAIBrain():GiveResource('Mass', self:GetBlueprint().Economy.BuildCostMass * self:GetBlueprint().Wreckage.MassMult )
        instigator:GetAIBrain():GiveResource('Energy', self:GetBlueprint().Economy.BuildCostEnergy * self:GetBlueprint().Wreckage.EnergyMult )
        if EntityCategoryContains(categories.HEALERCREEP, self) then
            local lifecrystal = instigator:GetAIBrain().LifeCrystal   
            if lifecrystal:GetHealth() > lifecrystal:GetMaxHealth() - 2 then
                lifecrystal:SetMaxHealth(lifecrystal:GetMaxHealth() + 1 )
            end
            lifecrystal:SetHealth(lifecrystal, lifecrystal:GetHealth() + 2)
        end
        if EntityCategoryContains(categories.BIGBOSS, self) and not ScenarioInfo.Options.TeaDEndless == 'true' then
            self:GetAIBrain():OnDefeat()
            --Victory
        end
        Unit.OnKilled(self, instigator, type, 2)
    end,
}
