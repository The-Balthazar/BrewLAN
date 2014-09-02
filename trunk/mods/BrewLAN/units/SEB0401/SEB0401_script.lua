#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB0301/UEB0301_script.lua
#**  Author(s):  David Tomandl
#**
#**  Summary  :  Terran Unit Script
#**
#**  Copyright © 2006 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TLandFactoryUnit = import('/lua/terranunits.lua').TLandFactoryUnit

SEB0401 = Class(TLandFactoryUnit) {

    OnLayerChange = function(self, new, old)
        TLandFactoryUnit.OnLayerChange(self, new, old)
        if new == 'Land' then
            self:AddBuildRestriction(categories.NAVAL)
            self:AddBuildRestriction(categories.AIR)
            self:RequestRefreshUI()
        elseif new == 'Water' then
            self:AddBuildRestriction(categories.LAND - categories.ENGINEER)
            self:AddBuildRestriction(categories.AIR)
            self:RequestRefreshUI()     
        end
    end,

    OnScriptBitSet = function(self, bit)
        TLandFactoryUnit.OnScriptBitSet(self, bit)
        if bit == 1 then
            self:RestoreBuildRestrictions()
            self:AddBuildRestriction(categories.NAVAL)
            self:AddBuildRestriction(categories.LAND - categories.ENGINEER)
        end
    end,

    OnScriptBitClear = function(self, bit)
        TLandFactoryUnit.OnScriptBitClear(self, bit)
        if bit == 1 then	    
            if self:GetCurrentLayer() == 'Land' then
                self:RestoreBuildRestrictions()
                self:AddBuildRestriction(categories.NAVAL)
                self:AddBuildRestriction(categories.AIR)
                self:RequestRefreshUI()
            elseif self:GetCurrentLayer() == 'Water' then
                self:RestoreBuildRestrictions()
                self:AddBuildRestriction(categories.LAND - categories.ENGINEER)
                self:AddBuildRestriction(categories.AIR)
                self:RequestRefreshUI()     
            end
        end
    end,

    StartBuildFx = function(self, unitBeingBuilt)
        if not unitBeingBuilt then
            unitBeingBuilt = self:GetFocusUnit()
        end
        
        # Start build process
        if not self.BuildAnimManip then
            self.BuildAnimManip = CreateAnimator(self)
            self.BuildAnimManip:PlayAnim(self:GetBlueprint().Display.AnimationBuild, true):SetRate(0)
            self.Trash:Add(self.BuildAnimManip)
        end

        self.BuildAnimManip:SetRate(1)
    end,
    
    StopBuildFx = function(self)
        if self.BuildAnimManip then
            self.BuildAnimManip:SetRate(0)
        end
    end,
    
    OnPaused = function(self)
        LandFactoryUnit.OnPaused(self)
        self:StopBuildFx(self:GetFocusUnit())
    end,

    OnUnpaused = function(self)
        LandFactoryUnit.OnUnpaused(self)
        if self:IsUnitState('Building') then
            self:StartBuildFx(self:GetFocusUnit())
        end
    end,
    
    DeathThread = function(self, overkillRatio, instigator) 
        for i = 1, 8 do
            local r = 1 - 2 * math.random(0,1)
            local a = 'ArmA_00' .. i
            local b = 'ArmB_00' .. i
            local c = 'ArmC_00' .. i
            local d = 'Nozzle_00' .. i
            self:ForkThread(self.Flailing, a, math.random(10,20), 'z', r)
            self:ForkThread(self.Flailing, b, math.random(35,45), 'x', r)
            self:ForkThread(self.Flailing, c, math.random(35,45), 'x', r)
            self:ForkThread(self.Flailing, d, math.random(35,45), 'x', r)
        end
        TLandFactoryUnit.DeathThread(self, overkillRatio, instigator)
    end,
    
    Flailing = function(self, bone, a, d, r)     
        local rotator = CreateRotator(self, bone, d) 
        self.Trash:Add(rotator)    
        rotator:SetGoal(a*r)
        rotator:SetSpeed(math.random(a*5,a*15)) 
        WaitFor(rotator)
        local m = 1
        while true do
            local f = math.random(a*5*m,a*15*m)
            m = m + (math.random(1,2)/10) 
            rotator:SetGoal((a+a)*(r*-1))
            rotator:SetSpeed(f)
            WaitFor(rotator)    
            rotator:SetGoal((a+a)*r)
            rotator:SetSpeed(f)
            if f > 1000 then
                CreateEmitterAtBone(self, bone, self:GetArmy(), '/effects/emitters/terran_bomber_bomb_explosion_06_emit.bp')
                CreateEmitterAtBone(self, bone, self:GetArmy(), '/effects/emitters/flash_05_emit.bp')
                CreateEmitterAtBone(self, bone, self:GetArmy(), '/effects/emitters/destruction_explosion_fire_01_emit.bp') 
                CreateEmitterAtBone(self, bone, self:GetArmy(), '/effects/emitters/destruction_explosion_fire_plume_01_emit.bp')          
                self:HideBone(bone, true)
                f = 0
            end
            WaitFor(rotator)
        end
    end,
}

TypeClass = SEB0401