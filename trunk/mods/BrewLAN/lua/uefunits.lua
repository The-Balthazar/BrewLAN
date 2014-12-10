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
        if instigator then
            if instigator and IsUnit(instigator) then
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
        end
    end,  
        
    PanicState = State {
        Main = function(self)
            local pos = self:GetPosition()  
            local aiBrain = self:GetAIBrain()
            
            local bp = self:GetBlueprint()
            local x = bp.Physics.SkirtSizeX / 2 + 1
            local z = bp.Physics.SkirtSizeZ / 2 + 1
            local sign = -1 + 2 * math.random(0, 1)
            
            if math.random(0, 1) > 0 then
                self.BuildGoalX = sign * x
                self.BuildGoalZ = math.random(-z, z)
            else
                self.BuildGoalX = math.random(-x, x)
                self.BuildGoalZ = sign * z
            end

            local halp = "Help, help, I'm being repressed!"  
            LOG(halp)
            aiBrain:BuildStructure(self, self.BuildThis or 'ueb2101', {pos[1]+self.BuildGoalX, pos[3]+self.BuildGoalZ, 0})
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