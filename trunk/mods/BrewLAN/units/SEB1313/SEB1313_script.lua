#****************************************************************************
#**
#**  File     :  /cdimage/units/UAB1303/UAB1303_script.lua
#**  Author(s):  Jessica St. Croix, David Tomandl
#**
#**  Summary  :  UEF T3 Mass Fabricator
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TMassFabricationUnit = import('/lua/terranunits.lua').TMassFabricationUnit    
local CConstructionStructureUnit = import('/lua/cybranunits.lua').CConstructionStructureUnit   
local EffectUtil = import('/lua/EffectUtilities.lua')


SEB1313 = Class(CConstructionStructureUnit) {

    OnStopBeingBuilt = function(self,builder,layer)
        CConstructionStructureUnit.OnStopBeingBuilt(self,builder,layer)
        self.Rotator = CreateRotator(self, 'Spinner', 'z')
        self.Rotator:SetAccel(10)
        self.Rotator:SetTargetSpeed(40)
        self.Trash:Add(self.Rotator)
		self.AmbientEffects = CreateEmitterAtEntity(self, self:GetArmy(), '/effects/emitters/uef_t3_massfab_ambient_01_emit.bp')
		self.Trash:Add(self.AmbientEffects)   
      ChangeState(self, self.ActiveState)     
    
    end,
             
    CreateBuildEffects = function( self, unitBeingBuilt, order )
        EffectUtil.CreateUEFBuildSliceBeams( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag )
    end,
    
    OnProductionPaused = function(self)
        CConstructionStructureUnit.OnProductionPaused(self)
        self.Rotator:SetSpinDown(true)
		if self.AmbientEffects then
			self.AmbientEffects:Destroy()
			self.AmbientEffects = nil
		end            
    end,
    
    OnProductionUnpaused = function(self)
        CConstructionStructureUnit.OnProductionUnpaused(self)
        self.Rotator:SetTargetSpeed(40)
        self.Rotator:SetSpinDown(false)
		self.AmbientEffects = CreateEmitterAtEntity(self, self:GetArmy(), '/effects/emitters/uef_t3_massfab_ambient_01_emit.bp')
		self.Trash:Add(self.AmbientEffects)          
    end,      
    OnDamage = function(self, instigator, amount, vector, damageType)
        CConstructionStructureUnit.OnDamage(self, instigator, amount, vector, damageType)
                
        self:PlaySound(self:GetBlueprint().Audio.PanicLoop)
        if not instigator:IsDead() or false then
            if EntityCategoryContains(categories.AIR, instigator) then
                self.BuildThis = 'ueb2104'
            elseif EntityCategoryContains(categories.SUBMERSIBLE, instigator) then
                self.BuildThis = 'ueb2109'
            else
                self.BuildThis = 'ueb2101'
            end
            ChangeState(self, self.PanicState)
        end
    end,
            
    PanicState = State {
        Main = function(self)
            local pos = self:GetPosition()  
            local aiBrain = self:GetAIBrain()
            
            local direction = math.random(4)
            if direction == 1 then
                self.BuildGoalX = -4
                self.BuildGoalY = math.random(-4,4)
            elseif direction == 2 then
                self.BuildGoalX = 4
                self.BuildGoalY = math.random(-4,4)
            elseif direction == 3 then
                self.BuildGoalX = math.random(-4,4)
                self.BuildGoalY = -4
            elseif direction == 4 then
                self.BuildGoalX = math.random(-4,4)
                self.BuildGoalY = 4
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
    ActiveState = State {       
        Main = function(self)
        end,

        OnInActive = function(self)
            ChangeState(self, self.InActiveState)
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

TypeClass = SEB1313