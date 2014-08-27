#****************************************************************************
#**
#**  Summary  :  UEF T3 Engineering Resource Generator/Fabricator 
#**
#****************************************************************************
                                                                       
local CConstructionStructureUnit = import('/lua/cybranunits.lua').CConstructionStructureUnit   
local EffectUtil = import('/lua/EffectUtilities.lua')                
local Utilities = import('/lua/utilities.lua')

TEngineeringResourceStructureUnit = Class(CConstructionStructureUnit) { 
    OnStopBeingBuilt = function(self,builder,layer)
        CConstructionStructureUnit.OnStopBeingBuilt(self,builder,layer)   
        ChangeState(self, self.ActiveState)
    end,
    
    CreateBuildEffects = function( self, unitBeingBuilt, order )
        local UpgradesFrom = unitBeingBuilt:GetBlueprint().General.UpgradesFrom
        # If we are assisting an upgrading unit, or repairing a unit, play seperate effects
        if (order == 'Repair' and not unitBeingBuilt:IsBeingBuilt()) or (UpgradesFrom and UpgradesFrom != 'none' and self:IsUnitState('Guarding'))then
            EffectUtil.CreateDefaultBuildBeams( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag )
        else
            EffectUtil.CreateUEFBuildSliceBeams( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag )        
        end           
    end,      
    
    OnDamage = function(self, instigator, amount, vector, damageType)
        CConstructionStructureUnit.OnDamage(self, instigator, amount, vector, damageType)
                
        self:PlaySound(self:GetBlueprint().Audio.PanicLoop)
        if not instigator:IsDead() or false then
            local layer = instigator:GetCurrentLayer()             
            local bp = self:GetBlueprint()
            local distance = Utilities.GetDistanceBetweenTwoEntities(self, instigator)
            if distance > bp.Intel.VisionRadius * 3 then 
                #LOG("Shit that's far: ".. distance)
                return
            elseif layer == 'Land' or self.AlternateWater  then
                self.BuildThis = bp.Economy.BuildWhenAttackedByLand or 'ueb2101'
            elseif layer == 'Air' then
                self.BuildThis = bp.Economy.BuildWhenAttackedByAir or 'ueb2104'
            elseif layer == 'Seabed' or layer == 'Sub' or layer == 'Water' then
                self.BuildThis = bp.Economy.BuildWhenAttackedBySub or 'ueb2109'
                if layer == 'Water' and not self.AlternateWater then
                    self.AlternateWater = true
                elseif layer == 'Water' then
                    self.AlternateWater = false
                end
            else
                return --what are we fighting here I dont even.
            end   
            #LOG("Instigator layer: ".. layer)
            ChangeState(self, self.PanicState)
        end
    end,  
        
    PanicState = State {
        Main = function(self)
            local pos = self:GetPosition()  
            local aiBrain = self:GetAIBrain()
            
            local direction = math.random(4)
            
            local bp = self:GetBlueprint()
            local x = bp.Physics.SkirtSizeX/2+1
            local y = bp.Physics.SkirtSizeZ/2+1
            
            if direction == 1 then
                self.BuildGoalX = -x
                self.BuildGoalY = math.random(-y,y)
            elseif direction == 2 then
                self.BuildGoalX = x
                self.BuildGoalY = math.random(-y,y)
            elseif direction == 3 then
                self.BuildGoalX = math.random(-x,x)
                self.BuildGoalY = -y
            elseif direction == 4 then
                self.BuildGoalX = math.random(-x,x)
                self.BuildGoalY = y
            end
            local halp = "Help, help, I'm being repressed!"  
            LOG(halp)
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