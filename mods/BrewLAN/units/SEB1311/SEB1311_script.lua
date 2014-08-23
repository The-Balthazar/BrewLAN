#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB1301/UEB1301_script.lua
#**  Author(s):  John Comes, Dave Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Tier 3 Power Generator Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TEnergyCreationUnit = import('/lua/terranunits.lua').TEnergyCreationUnit    
local CConstructionStructureUnit = import('/lua/cybranunits.lua').CConstructionStructureUnit   
local EffectUtil = import('/lua/EffectUtilities.lua')

SEB1311 = Class(CConstructionStructureUnit) {
    OnStopBeingBuilt = function(self,builder,layer)
        CConstructionStructureUnit.OnStopBeingBuilt(self,builder,layer)   
        ChangeState(self, self.ActiveState)
    end,

    ActiveState = State {
        Main = function(self)
            # Play the "activate" sound
            local myBlueprint = self:GetBlueprint()
            if myBlueprint.Audio.Activate then
                self:PlaySound(myBlueprint.Audio.Activate)
            end
        end,

        OnInActive = function(self)
            ChangeState(self, self.InActiveState)
        end,
    },
          
    CreateBuildEffects = function( self, unitBeingBuilt, order )
        EffectUtil.CreateUEFBuildSliceBeams( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag )
    end,
        
    OnDamage = function(self, instigator, amount, vector, damageType)
        CConstructionStructureUnit.OnDamage(self, instigator, amount, vector, damageType)
        
        if EntityCategoryContains(categories.AIR, instigator) then
            self.BuildThis = 'ueb2104'
        else
            self.BuildThis = 'ueb2101'
        end
        ChangeState(self, self.PanicState)
    end,
            
    PanicState = State {
        Main = function(self)
            local pos = self:GetPosition()  
            local aiBrain = self:GetAIBrain()
            
            local direction = math.random(4)
            if direction == 1 then
                self.BuildGoalX = -5
                self.BuildGoalY = math.random(-5,5)
            elseif direction == 2 then
                self.BuildGoalX = 5
                self.BuildGoalY = math.random(-5,5)
            elseif direction == 3 then
                self.BuildGoalX = math.random(-5,5)
                self.BuildGoalY = -5
            elseif direction == 4 then
                self.BuildGoalX = math.random(-5,5)
                self.BuildGoalY = 5
            end  
            --LOG("Direction: ", direction, " X: ", self.BuildGoalX, " Y: ", self.BuildGoalY)
            --if aiBrain:CanBuildStructureAt( 'ueb2101', {pos[1]+self.BuildGoalX, pos[3]+self.BuildGoalY, 0} ) then
            aiBrain:BuildStructure(self, self.BuildThis or 'ueb2101', {pos[1]+self.BuildGoalX, pos[3]+self.BuildGoalY, 0})
        end,   
        OnStopBuild = function(self, unitBuilding)
            CConstructionStructureUnit.OnStopBuild(self, unitBuilding)
            ChangeState(self, self.ActiveState)
        end,
        OnFailedToBuild = function(self)
            CConstructionStructureUnit.OnFailedToBuild(self)
            ChangeState(self, self.ActiveState)
        end,
    },
    
    InActiveState = State {
        Main = function(self)
        end,

        OnActive = function(self)
            ChangeState(self, self.ActiveState)
        end,
    },      
}

TypeClass = SEB1311